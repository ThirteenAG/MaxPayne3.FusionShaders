sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
float bumpiness : register(c201);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c197);
float specularColorFactor : register(c200);
float specularFactor : register(c199);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float3 texcoord7 : TEXCOORD7;
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
	float4 r4;
	float4 r5;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r1.xyz = 1E-05 + i.texcoord7.xyz;
	r1.z = dot(r1.xyz, r1.xyz);
	r1.z = rsqrt(r1.z);
	r1.xy = r1.zz * r1.xy;
	r1.xy = -r1.xy * parallaxScaleBias.xx;
	r2.xyz = r0.xyz;
	r3.yz = i.texcoord.xy;
	r3.x = -1;
	r3.w = -r0.w;
	for (int i0 = 0; i0 < 8; i0++) {
		r1.z = -r3.w + r3.x;
		r4.x = r3.x + 0.125;
		r4.yz = r1.xy * 0.125 + r3.yz;
		r5 = tex2D(BumpSampler, r4.yz);
		r4.w = -r5.w;
		r2.xyz = (r1.zzz >= 0) ? r2.xyz : r5.xyz;
		r3 = (r1.z >= 0) ? r3 : r4;
	}
	r0 = tex2D(DiffuseSampler, r3.yz);
	r1.xy = r2.xy * 2 + -1;
	r1.xy = r1.xy * bumpiness.xx;
	r1.z = dot(r1.xy, -r1.xy) + 1;
	r2.w = max(r1.z, 0);
	r1.z = rsqrt(r2.w);
	r1.z = 1 / r1.z;
	r3.z = -1;
	r1.w = -r3.z + -specularFactor.x;
	r3.xyz = r1.xxx * i.texcoord4.xyz;
	r3.xyz = r1.zzz * i.texcoord1.xyz + r3.xyz;
	r1.xyz = r1.yyy * i.texcoord5.xyz + r3.xyz;
	r1.xyz = r1.xyz + 1E-05;
	r3.xyz = normalize(r1.xyz);
	r1.x = dot(r2.xy, r2.xy) + -0.002;
	r1.x = (r1.x >= 0) ? 1 : 0;
	r1.y = r1.x * i.color.x;
	o.color2.x = r1.x * specularColorFactor.x;
	r0.w = r0.w * i.color.w;
	r1.z = saturate(i.color.x * r1.x + -1);
	r1.z = r1.z * globalScalars2.z;
	o.color.xyz = r0.xyz * r1.xxx + r1.zzz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.y = 0.0051020407;
	r0.x = saturate(r0.y * specularFactor.x);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r1.w >= 0) ? 0.26726124 : r0.x;
	o.color2.z = r1.y * gAmbientOcclusionEffect.w;
	r0.x = r0.w * globalScalars.x;
	r0.y = r0.w * r2.z;
	o.color1.w = r0.y * globalScalars.x;
	o.color.w = r0.x;
	o.color2.w = r0.x;
	o.color3 = r0.x * float4(0, 0, 0, 1);

	return o;
}
