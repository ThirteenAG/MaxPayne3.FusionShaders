sampler2D BumpSampler : register(s1);
sampler2D PuddleMaskSampler : register(s2);
sampler2D WaterRainRippleNormalSampler : register(s14);
float4 WetDarken : register(c202);
float bumpiness : register(c200);
float4 gWaterGlobals : register(c64);
float4 globalScalars : register(c35);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float2 texcoord6 : TEXCOORD6;
	float2 vpos : VPOS;
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
	float4 r2;
	float3 r3;
	r0.xy = 0.5 * i.vpos.xy;
	r0.xy = frac(abs(r0.xy));
	r0.xy = (i.vpos.xy >= 0) ? r0.xy : -r0.xy;
	r0.xy = r0.xy + r0.xy;
	r0.zw = frac(r0.xy);
	r0.xy = -r0.zw + r0.xy;
	r0.x = r0.y * 2 + r0.x;
	r0 = r0.x + float4(-0, -1, -2, -3);
	r0 = (-abs(r0) >= 0) ? 1 : 0;
	r0.x = dot(stipplePattern, r0);
	r0 = (r0.x >= 0) ? -1 : -0;
	clip(r0);
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r1.x = -r0.w + 1;
	r1.x = -r0.x + r1.x;
	r0.xy = (r1.xx >= 0) ? r0.wy : r0.xy;
	r0.xy = r0.xy * 2 + -1;
	r1.xy = r0.xy * bumpiness.xx;
	r0.x = dot(r1.xy, -r1.xy) + 1;
	r1.w = max(r0.x, 0);
	r0.x = rsqrt(r1.w);
	r1.z = 1 / r0.x;
	r0.xy = WetDarken.ww * i.texcoord6.xy;
	r2 = tex2D(PuddleMaskSampler, r0.xy);
	r0.x = r2.x + gWaterGlobals.y;
	r0.x = saturate(r0.x + -i.color.y);
	r0.yw = 0.3 * i.texcoord6.xy;
	r2 = tex2D(WaterRainRippleNormalSampler, r0.yw);
	r2.xyz = r2.xyz * 2 + -1;
	r2.xyz = r2.xyz * i.texcoord1.zzz + -r1.xyz;
	r2.xyz = r0.xxx * r2.xyz + r1.xyz;
	r2.xyz = r2.xyz + 1E-05;
	r3 = normalize(r2.xyz);
	r0.xyw = (-r0.xxx >= 0) ? r1.xyz : r3.xyz;
	r0.xyw = (-i.color.yyy >= 0) ? r1.xyz : r0.xyw;
	r1.xyz = r0.xxx * i.texcoord4.xyz;
	r1.xyz = r0.www * i.texcoord1.xyz + r1.xyz;
	r0.xyw = r0.yyy * i.texcoord5.xyz + r1.xyz;
	r0.xyw = r0.xyw + 1E-05;
	r1.xyz = normalize(r0.xyw);
	o.color1.xyz = r1.xyz * 0.5 + 0.5;
	r0.x = r0.z * i.color.w;
	o.color1.w = r0.x * globalScalars.x;
	o.color = 0;
	o.color2 = 0;
	o.color3 = 0;

	return o;
}
