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
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 texcoord6 : TEXCOORD6;
	float2 vpos : VPOS;
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
	float4 r4;
	float4 r5;
	float3 r6;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.w = r0.w * i.color.w;
	r1.x = r0.w * globalScalars.x;
	r1.yz = 0.5 * i.vpos.xy;
	r1.yz = frac(abs(r1.yz));
	r1.yz = (i.vpos.xy >= 0) ? r1.yz : -r1.yz;
	r1.yz = r1.yz + r1.yz;
	r2.xy = frac(r1.yz);
	r1.yz = r1.yz + -r2.xy;
	r1.y = r1.z * 2 + r1.y;
	r2 = r1.y + float4(-0, -1, -2, -3);
	r2 = (-abs(r2) >= 0) ? 1 : 0;
	r1.y = dot(stipplePattern, r2);
	r0.w = r0.w * -globalScalars.x + r1.y;
	r2 = (r0.w >= 0) ? -1 : -0;
	clip(r2);
	r2 = tex2D(BumpSampler, i.texcoord.xy);
	r0.w = -r2.w + 1;
	r0.w = -r2.x + r0.w;
	r1.yz = (r0.ww >= 0) ? r2.wy : r2.xy;
	r1.yz = r1.yz * 2 + -1;
	r2.xy = r1.yz * bumpiness.xx;
	r0.w = dot(r2.xy, -r2.xy) + 1;
	r1.y = max(r0.w, 0);
	r0.w = rsqrt(r1.y);
	r2.z = 1 / r0.w;
	r3 = tex2D(SpecSampler, i.texcoord.xy);
	r0.w = dot(r3, specMapExpMask);
	r0.w = r0.w * specularFactor.x;
	r3.x = dot(r3.xyz, specMapIntMask.xyz);
	r3.y = max(1, r0.w);
	r1.yz = WetDarken.ww * i.texcoord6.xy;
	r4 = tex2D(PuddleMaskSampler, r1.yz);
	r0.w = r4.x + gWaterGlobals.y;
	r0.w = saturate(r0.w + -i.color.y);
	r1.yzw = r0.xyz * WetDarken.xyz;
	r4.xy = lerp(r3.xy, gWaterGlobals.zw, r0.ww);
	r3.zw = 0.3 * i.texcoord6.xy;
	r5 = tex2D(WaterRainRippleNormalSampler, r3.zw);
	r5.xyz = r5.xyz * 2 + -1;
	r5.xyz = r5.xyz * i.texcoord1.zzz + -r2.xyz;
	r5.xyz = r0.www * r5.xyz + r2.xyz;
	r5.xyz = r5.xyz + 1E-05;
	r6 = normalize(r5.xyz);
	r2.w = saturate(gWaterGlobals.y);
	r5.xyz = r0.xyz * WetDarken.xyz + -r0.xyz;
	r5.xyz = r2.www * r5.xyz + r0.xyz;
	r1.yzw = (-r0.www >= 0) ? r5.xyz : r1.yzw;
	r5.xyz = (-r0.www >= 0) ? r2.xyz : r6.xyz;
	r3.zw = (-r0.ww >= 0) ? r3.xy : r4.xy;
	r2.xyz = (-i.color.yyy >= 0) ? r2.xyz : r5.xyz;
	r0.xyz = (-i.color.yyy >= 0) ? r0.xyz : r1.yzw;
	r1.yz = (-i.color.yy >= 0) ? r3.xy : r3.zw;
	r3.xyz = r2.xxx * i.texcoord4.xyz;
	r2.xzw = r2.zzz * i.texcoord1.xyz + r3.xyz;
	r2.xyz = r2.yyy * i.texcoord5.xyz + r2.xzw;
	r2.xyz = r2.xyz + 1E-05;
	r3.xyz = normalize(r2.xyz);
	r0.w = saturate(-1 + i.color.x);
	o.color.xyz = r0.www * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.x = saturate(r1.z * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = gAmbientOcclusionEffect.w * i.color.x;
	o.color.w = r1.x;
	o.color1.w = r1.x;
	o.color2.xw = r1.yx;
	r0.zw = float2(1, 0);
	o.color3 = r0.wwwz * gStencil.x;

	return o;
}
