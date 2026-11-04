sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c201);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c197);
float specularColorFactor : register(c200);
float specularFactor : register(c199);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
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
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r0.xyz = 1E-05 + i.texcoord7.xyz;
	r0.z = dot(r0.xyz, r0.xyz);
	r0.z = rsqrt(r0.z);
	r0.xy = r0.zz * r0.xy;
	r1.yw = float2(0.5, -1);
	r0.z = r1.y * parallaxScaleBias.x;
	r0.z = r0.w * parallaxScaleBias.x + -r0.z;
	r0.xy = saturate(r0.zz * r0.xy + i.texcoord.xy);
	r2 = tex2D(DiffuseSampler, r0.xy);
	r0.z = r2.w * i.color.w;
	r0.w = r0.z * globalScalars.x;
	r1.xy = 0.5 * i.vpos.xy;
	r1.xy = frac(abs(r1.xy));
	r1.xy = (i.vpos.xy >= 0) ? r1.xy : -r1.xy;
	r1.xy = r1.xy + r1.xy;
	r3.xy = frac(r1.xy);
	r1.xy = r1.xy + -r3.xy;
	r1.x = r1.y * 2 + r1.x;
	r3 = r1.x + float4(-0, -1, -2, -3);
	r3 = (-abs(r3) >= 0) ? 1 : 0;
	r1.x = dot(stipplePattern, r3);
	r1.x = r0.z * -globalScalars.x + r1.x;
	r3 = (r1.x >= 0) ? -1 : -0;
	clip(r3);
	r3 = tex2D(BumpSampler, r0.xy);
	r0.xy = r3.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r1.x = dot(r0.xy, -r0.xy) + 1;
	r2.w = max(r1.x, 0);
	r1.x = rsqrt(r2.w);
	r1.x = 1 / r1.x;
	r1.y = -r1.w + -specularFactor.x;
	r4 = r0.xxx * i.texcoord4.xyz;
	r1.xzw = r1.xxx * i.texcoord1.xyz + r4.xyz;
	r1.xzw = r0.yyy * i.texcoord5.xyz + r1.xzw;
	r1.xzw = r1.xzw + 1E-05;
	r4 = normalize(r1.xzw);
	r0.x = dot(r3.xy, r3.xy) + -0.002;
	r0.x = (r0.x >= 0) ? 1 : 0;
	r0.y = r0.x * i.color.x;
	o.color2.x = r0.x * specularColorFactor.x;
	r1.x = saturate(i.color.x * r0.x + -1);
	r1.x = r1.x * globalScalars2.z;
	o.color.xyz = r2.xyz * r0.xxx + r1.xxx;
	o.color1.xyz = r4.xyz * 0.5 + 0.5;
	r2.y = 0.0051020407;
	r0.x = saturate(r2.y * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r1.y >= 0) ? 0.26726124 : r0.x;
	o.color2.z = r0.y * gAmbientOcclusionEffect.w;
	r0.x = r0.z * r3.z;
	o.color1.w = r0.x * globalScalars.x;
	o.color.w = r0.w;
	o.color2.w = r0.w;
	o.color3 = r0.w * float4(0, 0, 0, 1);

	return o;
}
