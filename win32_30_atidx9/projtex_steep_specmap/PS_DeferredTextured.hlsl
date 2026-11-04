sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s3);
float bumpiness : register(c202);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float parallaxScaleBias : register(c197);
float4 specMapExpMask : register(c201);
float3 specMapIntMask : register(c200);
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
	float3 r6;
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
	r3 = tex2D(SpecSampler, i.texcoord.xy);
	r1.w = dot(r3, specMapExpMask);
	r2.w = r1.w * specularFactor.x;
	r3.x = dot(r3.xyz, specMapIntMask.xyz);
	r3.z = -1;
	r1.w = r1.w * -specularFactor.x + -r3.z;
	r3.yzw = r1.xxx * i.texcoord4.xyz;
	r3.yzw = r1.zzz * i.texcoord1.xyz + r3.yzw;
	r1.xyz = r1.yyy * i.texcoord5.xyz + r3.yzw;
	r1.xyz = r1.xyz + 1E-05;
	r4.xyz = normalize(r1.xyz);
	r1.x = dot(r2.xy, r2.xy) + -0.002;
	r1.x = (r1.x >= 0) ? 1 : 0;
	r3.yzw = r0.xyz * r1.xxx;
	r5.z = r1.x * i.color.x;
	o.color2.x = r1.x * r3.x;
	r0.w = r0.w * i.color.w;
	r1.y = dot(r3.yzw, float3(0.2125, 0.7154, 0.0721));
	r6 = r0.xyz * r1.xxx + -r1.yyy;
	r6 = gAdrenoFXVars.xxx * r6.xyz + r1.yyy;
	r1.y = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r0.xyz = r0.xyz * -r1.xxx + r6.xyz;
	r0.xyz = r1.yyy * r0.xyz + r3.yzw;
	r1.x = saturate(i.color.x * r1.x + -1);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r4.xyz * 0.5 + 0.5;
	r0.x = saturate(r2.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	o.color2.y = (r1.w >= 0) ? 0.071428575 : r0.x;
	r5.w = r0.w * globalScalars.x;
	r0.x = r0.w * r2.z;
	o.color1.w = r0.x * globalScalars.x;
	o.color.w = r5.w;
	o.color2.zw = r5.zw;
	o.color3 = r5.w * float4(0, 0, 0, 1);

	return o;
}
