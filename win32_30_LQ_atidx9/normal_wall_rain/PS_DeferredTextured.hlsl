sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
float4 RainNormalControls : register(c201);
sampler2D RainNormalSampler : register(s2);
float4 WetDarken : register(c200);
float bumpiness : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float specularColorFactor : register(c197);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
};

struct PS_OUT
{
	float4 color : COLOR;
	float4 color1 : COLOR1;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	r0.x = saturate(-1 + i.color.x);
	r0.y = saturate(gWaterGlobals.y);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2.xyz = r1.xyz * WetDarken.xyz + -r1.xyz;
	r0.yzw = r0.yyy * r2.xyz + r1.xyz;
	r2.xyz = r1.xyz * WetDarken.xyz;
	r2.w = saturate(gWaterGlobals.y + -i.color.y);
	r0.yzw = (-r2.www >= 0) ? r0.yzw : r2.xyz;
	r0.yzw = (-i.color.yyy >= 0) ? r1.xyz : r0.yzw;
	r1.x = r1.w * i.color.w;
	r1.x = r1.x * globalScalars.x;
	o.color.xyz = r0.xxx * globalScalars2.zzz + r0.yzw;
	r0.y = globalScalars2.y;
	r0.xy = r0.yy * RainNormalControls.zw;
	r0.xy = i.texcoord.xy * RainNormalControls.xy + r0.xy;
	r0 = tex2D(RainNormalSampler, r0.xy);
	r0.z = -r0.w + 1;
	r0.z = -r0.x + r0.z;
	r0.xy = (r0.zz >= 0) ? r0.wy : r0.xy;
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * WetDarken.ww;
	r0.w = dot(r0.xy, -r0.xy) + 1;
	r1.y = max(r0.w, 0);
	r0.w = rsqrt(r1.y);
	r0.z = 1 / r0.w;
	r3 = tex2D(BumpSampler, i.texcoord.xy);
	r0.w = -r3.w + 1;
	r0.w = -r3.x + r0.w;
	r1.yz = (r0.ww >= 0) ? r3.wy : r3.xy;
	r1.yz = r1.yz * 2 + -1;
	r2.xy = r1.yz * bumpiness.xx;
	r0.w = dot(r2.xy, -r2.xy) + 1;
	r1.y = max(r0.w, 0);
	r0.w = rsqrt(r1.y);
	r2.z = 1 / r0.w;
	r1.yzw = lerp(r2.xyz, r0.xyz, r2.www);
	r0.xyz = r1.yzw + 1E-05;
	r3.xyz = normalize(r0.xyz);
	r0.xyz = (-r2.www >= 0) ? r2.xyz : r3.xyz;
	r0.xyz = (-i.color.yyy >= 0) ? r2.xyz : r0.xyz;
	r1.yzw = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r1.yzw;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r2.xyz = normalize(r0.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.z = gWaterGlobals.z;
	r3.x = lerp(specularColorFactor.x, r0.z, r2.w);
	r0.xw = float2(1, 0);
	r2.y = max(r0.x, specularFactor.x);
	r3.y = lerp(r2.y, gWaterGlobals.w, r2.w);
	r2.x = specularColorFactor.x;
	r0.yz = (-r2.ww >= 0) ? r2.xy : r3.xy;
	r0.yz = (-i.color.yy >= 0) ? r2.xy : r0.yz;
	r0.z = saturate(r0.z * 0.0051020407);
	o.color2.x = r0.y;
	r0.y = rsqrt(r0.z);
	r0.y = 1 / r0.y;
	r0.y = rsqrt(r0.y);
	o.color2.y = 1 / r0.y;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.w = r1.x;
	o.color3 = r0.wwwx * gStencil.x;

	return o;
}
