sampler2D DiffuseSampler : register(s0);
sampler2D DirtSampler : register(s2);
sampler2D SpecSampler : register(s3);
float3 dirtColor : register(c200);
float dirtLevel : register(c199);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c197);
float4 matDiffuseColor2 : register(c198);
float4 specMapExpMask : register(c204);
float3 specMapIntMask : register(c203);
float specularColorFactor : register(c202);
float specularFactor : register(c201);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
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
	float4 r4;
	float4 r5;
	float4 r6;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.xyz);
	r1 = tex2D(SpecSampler, i.texcoord.xy);
	r1.w = dot(r1, specMapExpMask);
	r1.w = r1.w * specularFactor.x;
	r1.x = dot(r1.xyz, specMapIntMask.xyz);
	r1.x = r1.x * specularColorFactor.x;
	r2.w = max(1, r1.w);
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r0 = r0 * i.texcoord2;
	r1.y = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.z = globalScalars.z;
	r1.z = r1.z * gAmbientOcclusionEffect.y;
	r1.w = r1.z * r1.y;
	r3.yz = float2(1, 0);
	if (-dirtLevel.x < r3.z) {
		r4 = tex2D(DirtSampler, i.texcoord.xy);
		r3.x = r4.x * dirtLevel.x;
		r5.x = r4.x * -dirtLevel.x + r3.y;
		r5.yzw = lerp(r0.xyz, dirtColor.xyz, r3.xxx);
		r6 = r0.xxyz * float4(0, 1, 1, 1) + float4(1, 0, 0, 0);
		r4 = (-r4.x >= 0) ? r6 : r5;
		r0.xyz = r4.yzw;
	} else {
		r4.x = 1;
	}
	r1.x = r1.x * r4.x;
	o.color2.x = r1.x * matDiffuseColor2.w;
	r1.x = r2.w * matDiffuseColor2.w;
	r1.y = saturate(r1.y * r1.z + -1);
	o.color.xyz = r1.yyy * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.x = saturate(r1.x * 0.0051020407);
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	r0.x = r0.w * globalScalars.x;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color2.z = r1.w;
	o.color3 = r3.zzzy * gStencil.x;

	return o;
}
