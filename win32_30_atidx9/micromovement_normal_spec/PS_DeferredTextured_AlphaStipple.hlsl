sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c199);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDistFadeParams : register(c97);
float4 gStencil : register(c61);
row_major float4x4 gViewInverse : register(c12);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float4 specMapExpMask : register(c198);
float3 specMapIntMask : register(c197);
float specularFactor : register(c196);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float2 vpos : VPOS;
};

struct PS_OUT
{
	float4 color2 : COLOR2;
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float3 r4;
	float3 r5;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r2.xyz = float3(-0.5, 0, 1);
	r0.w = r0.w * globalScalars.x + r2.x;
	r3 = min(r0.w, 0);
	clip(r3);
	r0.w = (r0.w >= 0) ? 1 : r1.x;
	r1.yzw = -gViewInverse[3].xyz + i.texcoord6.xyz;
	r1.y = dot(r1.yzw, r1.yzw);
	r1.y = rsqrt(r1.y);
	r1.y = 1 / r1.y;
	r1.yz = r1.yy + float2(-0.65, -0.9);
	r1.y = saturate(r1.y);
	r1.y = r1.y + -1;
	r1.y = (r1.z >= 0) ? r1.y : -0.75;
	r1.y = gDistFadeParams.x * r1.y + r2.z;
	r1.z = r0.w * r1.y;
	r2.xw = 0.5 * i.vpos.xy;
	r2.xw = frac(abs(r2.xw));
	r2.xw = (i.vpos.xy >= 0) ? r2.xw : -r2.xw;
	r2.xw = r2.xw + r2.xw;
	r3.xy = frac(r2.xw);
	r2.xw = r2.xw + -r3.xy;
	r1.w = r2.w * 2 + r2.x;
	r3 = r1.w + float4(-0, -1, -2, -3);
	r3 = (-abs(r3) >= 0) ? 1 : 0;
	r1.w = dot(stipplePattern, r3);
	r0.w = r0.w * -r1.y + r1.w;
	r3 = (r0.w >= 0) ? -1 : -0;
	clip(r3);
	r3 = tex2D(BumpSampler, i.texcoord.xy);
	r0.w = -r3.w + 1;
	r0.w = -r3.x + r0.w;
	r1.yw = (r0.ww >= 0) ? r3.wy : r3.xy;
	r1.yw = r1.yw * 2 + -1;
	r1.yw = r1.yw * bumpiness.xx;
	r0.w = dot(r1.yw, -r1.yw) + 1;
	r2.x = max(r0.w, 0);
	r0.w = rsqrt(r2.x);
	r0.w = 1 / r0.w;
	r3 = tex2D(SpecSampler, i.texcoord.xy);
	r2.x = dot(r3, specMapExpMask);
	r2.w = r2.x * specularFactor.x;
	o.color2.x = dot(r3.xyz, specMapIntMask.xyz);
	r2.x = r2.x * -specularFactor.x + r2.z;
	r3.xyz = r1.yyy * i.texcoord4.xyz;
	r3.xyz = r0.www * i.texcoord1.xyz + r3.xyz;
	r3.xyz = r1.www * i.texcoord5.xyz + r3.xyz;
	r3.xyz = r3.xyz + 1E-05;
	r4 = normalize(r3.xyz);
	r0.w = dot(r0.xyz, float3(0.2125, 0.7154, 0.0721));
	r3.xyz = lerp(r0.www, r0.xyz, gAdrenoFXVars.xxx);
	r0.w = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r5 = lerp(r0.xyz, r3.xyz, r0.www);
	r0.x = saturate(-1 + i.color.x);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r5.xyz;
	o.color1.xyz = r4.xyz * 0.5 + 0.5;
	r0.x = saturate(r2.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r2.x >= 0) ? 0.071428575 : r0.x;
	o.color.w = r1.z;
	o.color1.w = r1.x;
	o.color2.z = i.color.x;
	o.color2.w = r1.x;
	o.color3 = r2.yyyz * gStencil.x;

	return o;
}
