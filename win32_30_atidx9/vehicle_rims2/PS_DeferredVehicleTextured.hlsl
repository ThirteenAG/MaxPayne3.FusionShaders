sampler2D DiffuseSampler : register(s0);
sampler2D DirtSampler : register(s1);
sampler2D SpecSampler : register(s2);
float3 dirtColor : register(c199);
float dirtLevel : register(c198);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDirectionalLight : register(c19);
float4 gStencil : register(c61);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c196);
float4 matDiffuseColor2 : register(c197);
float4 specMapExpMask : register(c203);
float3 specMapIntMask : register(c202);
float specular2ColorIntensity : register(c205);
float specular2Factor : register(c204);
float specularColorFactor : register(c201);
float specularFactor : register(c200);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
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
	r3.xyz = float3(1E-05, 1, 0);
	if (-dirtLevel.x < r3.z) {
		r4 = tex2D(DirtSampler, i.texcoord.xy);
		r3.w = r4.x * dirtLevel.x;
		r5.x = r4.x * -dirtLevel.x + r3.y;
		r5.yzw = lerp(r0.xyz, dirtColor.xyz, r3.www);
		r6 = r0.xxyz * float4(0, 1, 1, 1) + float4(1, 0, 0, 0);
		r4 = (-r4.x >= 0) ? r6 : r5;
		r0.xyz = r4.yzw;
	} else {
		r4.x = 1;
	}
	r3.w = r1.x * r4.x;
	r4.y = 1 / specularFactor.x;
	r4.y = r2.w * r4.y;
	r4.z = 1 / specularColorFactor.x;
	r1.x = r1.x * r4.z;
	r4.z = specular2ColorIntensity.x * specular2ColorIntensity.x;
	r1.x = r1.x * r4.z;
	r5.xyz = 1E-05 + i.texcoord3.xyz;
	r6.xyz = normalize(r5.xyz);
	r4.z = dot(-r6.xyz, r2.xyz);
	r4.z = r4.z + r4.z;
	r5.xyz = r2.xyz * -r4.zzz + -r6.xyz;
	r4.z = dot(r2.xyz, -gDirectionalLight.xyz);
	r4.w = saturate(dot(-gDirectionalLight.xyz, r5.xyz));
	r4.w = r4.w + 1E-05;
	r3.x = specular2Factor.x * r4.y + r3.x;
	r5.x = pow(r4.w, r3.x);
	r3.x = saturate(r4.z * 2 + -0.5);
	r3.x = (r4.z >= 0) ? r3.x : 0;
	r3.x = r3.x * r5.x;
	r1.x = r1.x * r3.x;
	r4.yzw = r0.xyz * r1.xxx;
	r4.xyz = r4.yzw * r4.xxx + r0.xyz;
	r0.xyz = (-specular2ColorIntensity.xxx >= 0) ? r0.xyz : r4.xyz;
	o.color2.x = r3.w * matDiffuseColor2.w;
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
