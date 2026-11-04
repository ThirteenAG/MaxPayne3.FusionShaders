sampler2D DiffuseSampler : register(s0);
sampler2D SpecSampler : register(s1);
float4 gAdrenoFXVars : register(c68);
float4 gAmbientOcclusionEffect : register(c63);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float4 specMapExpMask : register(c200);
float3 specMapIntMask : register(c199);
float specularFactor : register(c198);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
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
	float3 r2;
	float3 r3;
	r0 = tex2D(SpecSampler, i.texcoord.xy);
	o.color2.x = dot(r0.xyz, specMapIntMask.xyz);
	r0.x = dot(r0, specMapExpMask);
	r0.y = saturate(gAmbientOcclusionEffect.z + gAmbientOcclusionEffect.z);
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.z = dot(r1.xyz, float3(0.2125, 0.7154, 0.0721));
	r2 = lerp(r0.zzz, r1.xyz, gAdrenoFXVars.xxx);
	r3 = lerp(r1.xyz, r2.xyz, r0.yyy);
	r0.y = r1.w * i.color.w;
	r0.y = r0.y * globalScalars.x;
	r0.z = saturate(-1 + i.color.x);
	o.color.xyz = r0.zzz * globalScalars2.zzz + r3.xyz;
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2 = normalize(r1.xyz);
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.z = r0.x * specularFactor.x;
	r1.y = 1;
	r0.x = r0.x * -specularFactor.x + r1.y;
	r0.z = saturate(r0.z * 0.0051020407);
	r0.z = rsqrt(r0.z);
	r0.z = 1 / r0.z;
	o.color2.y = (r0.x >= 0) ? 0.071428575 : r0.z;
	o.color.w = r0.y;
	o.color1.w = r0.y;
	o.color2.z = i.color.x;
	o.color2.w = r0.y;
	o.color3 = r0.y * float4(0, 0, 0, 1);

	return o;
}
