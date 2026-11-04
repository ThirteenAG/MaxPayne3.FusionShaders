sampler2D BumpSampler : register(s1);
sampler2D DiffuseSampler : register(s0);
sampler2D PuddleMaskSampler : register(s2);
sampler2D SpecSampler : register(s3);
sampler2D WaterRainRippleNormalSampler : register(s14);
float4 WetDarken : register(c201);
float bumpiness : register(c199);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float4 specMapExpMask : register(c198);
float3 specMapIntMask : register(c197);
float specularFactor : register(c196);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 texcoord6 : TEXCOORD6;
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
	float3 r3;
	r0.x = saturate(gWaterGlobals.y);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.yzw = r1.xyz * WetDarken.xyz + -r1.xyz;
	r0.xyz = r0.xxx * r0.yzw + r1.xyz;
	r2.xy = WetDarken.ww * i.texcoord6.xy;
	r2 = tex2D(PuddleMaskSampler, r2.xy);
	r0.w = r2.x + gWaterGlobals.y;
	r0.w = saturate(r0.w + -i.color.y);
	r2.xyz = r1.xyz * WetDarken.xyz;
	r0.xyz = (-r0.www >= 0) ? r0.xyz : r2.xyz;
	r0.xyz = (-i.color.yyy >= 0) ? r1.xyz : r0.xyz;
	r1.x = r1.w * i.color.w;
	r1.x = r1.x * globalScalars.x;
	r1.y = saturate(-1 + i.color.x);
	o.color.xyz = r1.yyy * globalScalars2.zzz + r0.xyz;
	r0.xy = 0.3 * i.texcoord6.xy;
	r2 = tex2D(WaterRainRippleNormalSampler, r0.xy);
	r0.xyz = r2.xyz * 2 + -1;
	r2 = tex2D(BumpSampler, i.texcoord.xy);
	r1.y = -r2.w + 1;
	r1.y = -r2.x + r1.y;
	r1.yz = (r1.yy >= 0) ? r2.wy : r2.xy;
	r1.yz = r1.yz * 2 + -1;
	r2.xy = r1.yz * bumpiness.xx;
	r1.y = dot(r2.xy, -r2.xy) + 1;
	r2.w = max(r1.y, 0);
	r1.y = rsqrt(r2.w);
	r2.z = 1 / r1.y;
	r0.xyz = r0.xyz * i.texcoord1.zzz + -r2.xyz;
	r0.xyz = r0.www * r0.xyz + r2.xyz;
	r0.xyz = r0.xyz + 1E-05;
	r3 = normalize(r0.xyz);
	r0.xyz = (-r0.www >= 0) ? r2.xyz : r3.xyz;
	r0.xyz = (-i.color.yyy >= 0) ? r2.xyz : r0.xyz;
	r1.yzw = r0.xxx * i.texcoord4.xyz;
	r1.yzw = r0.zzz * i.texcoord1.xyz + r1.yzw;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r1.yzw;
	r0.xyz = r0.xyz + 1E-05;
	r2.xyz = normalize(r0.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r2 = tex2D(SpecSampler, i.texcoord.xy);
	r0.x = dot(r2, specMapExpMask);
	r2.x = dot(r2.xyz, specMapIntMask.xyz);
	r0.x = r0.x * specularFactor.x;
	r2.y = max(1, r0.x);
	r1.yz = lerp(r2.xy, gWaterGlobals.zw, r0.ww);
	r0.xy = (-r0.ww >= 0) ? r2.xy : r1.yz;
	r0.xy = (-i.color.yy >= 0) ? r2.xy : r0.xy;
	r0.y = saturate(r0.y * 0.0051020407);
	o.color2.x = r0.x;
	r0.x = rsqrt(r0.y);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.w = r1.x;
	r0.xw = float2(1, 0);
	o.color3 = r0.wwwx * gStencil.x;

	return o;
}
