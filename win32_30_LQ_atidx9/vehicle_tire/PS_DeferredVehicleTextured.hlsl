sampler2D BumpSampler : register(s2);
sampler2D DiffuseSampler : register(s0);
sampler2D DirtSampler : register(s1);
sampler2D SpecSampler : register(s3);
float3 dirtColor : register(c199);
float dirtLevel : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c196);
float4 matDiffuseColor2 : register(c197);
float4 specMapExpMask : register(c203);
float3 specMapIntMask : register(c202);
float specularColorFactor : register(c201);
float specularFactor : register(c200);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
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
	float3 r3;
	float3 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r0.z = -r0.w + 1;
	r0.z = -r0.x + r0.z;
	r0.xy = (r0.zz >= 0) ? r0.wy : r0.xy;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * 3;
	r0.z = dot(r0.xy, -r0.xy) + 1;
	r2.x = max(r0.z, 0);
	r0.z = rsqrt(r2.x);
	r0.z = 1 / r0.z;
	r2 = tex2D(SpecSampler, i.texcoord.xy);
	r0.w = dot(r2, specMapExpMask);
	r0.w = r0.w * specularFactor.x;
	r2.x = dot(r2.xyz, specMapIntMask.xyz);
	r2.x = r2.x * specularColorFactor.x;
	r2.y = max(1, r0.w);
	r3 = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r3.xyz;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r3 = normalize(r0.xyz);
	r1.xyz = r1.xyz * matDiffuseColor.xyz;
	r0 = r1 * i.texcoord2;
	r1.x = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.z = globalScalars.z;
	r1.y = r1.z * gAmbientOcclusionEffect.y;
	r1.z = r1.y * r1.x;
	r4.xz = float2(0, 1);
	if (-dirtLevel.x < r4.x) {
		r5 = tex2D(DirtSampler, i.texcoord.xy);
		r1.w = r5.x * dirtLevel.x;
		r6.x = 1;
		r6.x = r5.x * -dirtLevel.x + r6.x;
		r6.yzw = lerp(r0.xyz, dirtColor.xyz, r1.www);
		r7 = r0.xxyz * float4(0, 1, 1, 1) + float4(1, 0, 0, 0);
		r5 = (-r5.x >= 0) ? r7 : r6;
		r0.xyz = r5.yzw;
	} else {
		r5.x = 1;
	}
	r1.w = r2.x * r5.x;
	o.color2.x = r1.w * matDiffuseColor2.w;
	r1.w = r2.y * matDiffuseColor2.w;
	r1.x = saturate(r1.x * r1.y + -1);
	o.color.xyz = r1.xxx * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r3.xyz * 0.5 + 0.5;
	r0.x = saturate(r1.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = r1.z * gAmbientOcclusionEffect.w;
	r0.x = r0.w * globalScalars.x;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color3 = r4.xxxz * gStencil.x;

	return o;
}
