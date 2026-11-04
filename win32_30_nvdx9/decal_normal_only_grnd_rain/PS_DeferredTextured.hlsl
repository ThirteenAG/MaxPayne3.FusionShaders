sampler2D BumpSampler : register(s1);
sampler2D PuddleMaskSampler : register(s2);
sampler2D WaterRainRippleNormalSampler : register(s14);
float4 WetDarken : register(c202);
float bumpiness : register(c200);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 texcoord6 : TEXCOORD6;
	float4 color : COLOR;
};

struct PS_OUT
{
	float4 color1 : COLOR1;
	float4 color : COLOR;
	float4 color2 : COLOR2;
	float4 color3 : COLOR3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.xy = WetDarken.ww * i.texcoord6.xy;
	r0 = tex2D(PuddleMaskSampler, r0.xy);
	r0.x = r0.x + gWaterGlobals.y;
	r0.x = saturate(r0.x + -i.color.y);
	r0.yz = 0.3 * i.texcoord6.xy;
	r1 = tex2D(WaterRainRippleNormalSampler, r0.yz);
	r0.yzw = r1.xyz * 2 + -1;
	r1 = tex2D(BumpSampler, i.texcoord.xy);
	r2.x = -r1.w + 1;
	r2.x = -r1.x + r2.x;
	r1.xy = (r2.xx >= 0) ? r1.wy : r1.xy;
	r1.z = r1.z * i.color.w;
	o.color1.w = r1.z * globalScalars.x;
	r1.xy = r1.xy * 2 + -1;
	r1.xy = r1.xy * bumpiness.xx;
	r1.w = dot(r1.xy, -r1.xy) + 1;
	r2.x = max(r1.w, 0);
	r1.w = rsqrt(r2.x);
	r1.z = 1 / r1.w;
	r0.yzw = r0.yzw * i.texcoord1.zzz + -r1.xyz;
	r0.yzw = r0.xxx * r0.yzw + r1.xyz;
	r0.yzw = r0.yzw + 1E-05;
	r2 = normalize(r0.yzw);
	r0.xyz = (-r0.xxx >= 0) ? r1.xyz : r2.xyz;
	r0.xyz = (-i.color.yyy >= 0) ? r1.xyz : r0.xyz;
	r1.xyz = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r1.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r1.xyz = normalize(r0.xyz);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	o.color = 0;
	o.color2 = 0;
	o.color3 = 0;

	return o;
}
