sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s2);
float bumpiness : register(c199);
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
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r2.xyz = float3(-0.5, 0, -1);
	r0.w = r0.w * globalScalars.x + r2.x;
	r3 = (r0.w >= 0) ? 0 : -1;
	clip(r3);
	r1.yzw = -gViewInverse[3].xyz + i.texcoord6.xyz;
	r1.y = dot(r1.yzw, r1.yzw);
	r1.y = rsqrt(r1.y);
	r1.y = 1 / r1.y;
	r1.yz = r1.yy + float2(-0.65, -0.9);
	r1.y = saturate(r1.y);
	r1.y = r1.y + -1;
	r1.y = (r1.z >= 0) ? r1.y : -0.75;
	r1.y = gDistFadeParams.x * r1.y + -r2.z;
	r0.w = (r0.w >= 0) ? r1.y : 0;
	r1.yz = 0.5 * i.vpos.xy;
	r1.yz = frac(abs(r1.yz));
	r1.yz = (i.vpos.xy >= 0) ? r1.yz : -r1.yz;
	r1.yz = r1.yz + r1.yz;
	r2.xw = frac(r1.yz);
	r1.yz = r1.yz + -r2.xw;
	r1.y = r1.z * 2 + r1.y;
	r3 = r1.y + float4(-0, -1, -2, -3);
	r3 = (-abs(r3) >= 0) ? 1 : 0;
	r1.y = dot(stipplePattern, r3);
	r1.y = -r0.w + r1.y;
	r3 = (r1.y >= 0) ? -1 : -0;
	clip(r3);
	r3 = tex2D(BumpSampler, i.texcoord.xy);
	r1.y = -r3.w + 1;
	r1.y = -r3.x + r1.y;
	r1.yz = (r1.yy >= 0) ? r3.wy : r3.xy;
	r1.yz = r1.yz * 2 + -1;
	r1.yz = r1.yz * bumpiness.xx;
	r1.w = dot(r1.yz, -r1.yz) + 1;
	r2.x = max(r1.w, 0);
	r1.w = rsqrt(r2.x);
	r1.w = 1 / r1.w;
	r3 = tex2D(SpecSampler, i.texcoord.xy);
	r2.x = dot(r3, specMapExpMask);
	r2.w = r2.x * specularFactor.x;
	o.color2.x = dot(r3.xyz, specMapIntMask.xyz);
	r2.x = r2.x * -specularFactor.x + -r2.z;
	r3.xyz = r1.yyy * i.texcoord4.xyz;
	r3.xyz = r1.www * i.texcoord1.xyz + r3.xyz;
	r1.yzw = r1.zzz * i.texcoord5.xyz + r3.xyz;
	r1.yzw = r1.yzw + 1E-05;
	r3.xyz = normalize(r1.yzw);
	r1.y = saturate(-1 + i.color.x);
	o.color.xyz = r1.yyy * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.x = saturate(r2.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r2.x >= 0) ? 0.26726124 : r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = r0.w;
	o.color1.w = r1.x;
	o.color2.w = r1.x;
	o.color3 = abs(r2.yyyz) * gStencil.x;

	return o;
}
