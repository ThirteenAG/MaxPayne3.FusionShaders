sampler2D DiffuseSampler : register(s0);
sampler2D DirtSampler : register(s2);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D SpecSampler : register(s3);
float3 dirtColor : register(c200);
float dirtLevel : register(c199);
float fresnelRolloff : register(c210);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDirectionalLight : register(c19);
float4 gStencil : register(c61);
float4 globalFogColorN : register(c50);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c197);
float4 matDiffuseColor2 : register(c198);
float reflectivePower : register(c209);
float4 specMapExpMask : register(c204);
float3 specMapIntMask : register(c203);
float3 specMapReflectMask : register(c211);
float3 specular2Color : register(c207);
float specular2ColorIntensity : register(c206);
float specular2Factor : register(c205);
float specularColorFactor : register(c202);
float specularFactor : register(c201);

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
	float4 r7;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1.xyz = 1E-05 + i.texcoord1.xyz;
	r2.xyz = normalize(r1.xyz);
	r1 = tex2D(SpecSampler, i.texcoord.xy);
	r1.w = dot(r1, specMapExpMask);
	r1.w = r1.w * specularFactor.x;
	r2.w = dot(r1.xyz, specMapIntMask.xyz);
	r2.w = r2.w * specularColorFactor.x;
	r3.x = max(1, r1.w);
	r4.xyz = float3(1E-05, 1, 0);
	if (-reflectivePower.x < r4.z) {
		r3.yzw = 1E-05 + i.texcoord3.xyz;
		r5.xyz = normalize(r3.yzw);
		r1.w = dot(-r5.xyz, r2.xyz);
		r1.w = r1.w + r1.w;
		r3.yzw = r2.xyz * -r1.www + -r5.xyz;
		r3.yzw = r3.yzw + 1E-05;
		r6.xyz = normalize(r3.yzw);
		r1.w = saturate(r6.z);
		r1.w = r1.w + 1;
		r1.w = r1.w + r1.w;
		r1.w = 1 / r1.w;
		r3.yz = r6.xy * r1.ww + 0.5;
		r6.xy = -r3.yz + 1;
		r6.zw = 0;
		r6 = tex2Dlod(DynamicEnvironmentSampler, r6);
		r3.yzw = r6.xyz * r6.xyz;
		r3.yzw = r3.yzw * 16;
		r1.w = saturate(dot(r5.xyz, r2.xyz));
		r4.w = r4.y + -fresnelRolloff.x;
		r1.w = -r1.w + 1.00001;
		r5.x = r1.w * r1.w;
		r5.x = r5.x * r5.x;
		r1.w = r1.w * r5.x;
		r1.w = fresnelRolloff.x * r1.w + r4.w;
		r3.yzw = r1.www * r3.yzw;
	} else {
		r3.yzw = 0;
	}
	r3.yzw = r3.yzw * reflectivePower.xxx;
	r1.x = dot(r1.xyz, specMapReflectMask.xyz);
	r1.xyz = r1.xxx * r3.yzw;
	r1.xyz = r1.xyz * globalFogColorN.www;
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r0 = r0 * i.texcoord2;
	r1.w = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r3.z = globalScalars.z;
	r3.y = r3.z * gAmbientOcclusionEffect.y;
	r3.z = r1.w * r3.y;
	if (-dirtLevel.x < r4.z) {
		r5 = tex2D(DirtSampler, i.texcoord.xy);
		r3.w = r5.x * dirtLevel.x;
		r6.x = r5.x * -dirtLevel.x + r4.y;
		r6.yzw = lerp(r0.xyz, dirtColor.xyz, r3.www);
		r7 = r0.xxyz * float4(0, 1, 1, 1) + float4(1, 0, 0, 0);
		r5 = (-r5.x >= 0) ? r7 : r6;
		r0.xyz = r5.yzw;
	} else {
		r5.x = 1;
	}
	r3.w = r2.w * r5.x;
	r4.y = 1 / specularFactor.x;
	r4.y = r3.x * r4.y;
	r4.z = 1 / specularColorFactor.x;
	r2.w = r2.w * r4.z;
	r4.z = specular2ColorIntensity.x * specular2ColorIntensity.x;
	r2.w = r2.w * r4.z;
	r5.yzw = 1E-05 + i.texcoord3.xyz;
	r6.xyz = normalize(r5.yzw);
	r5.yzw = r2.www * specular2Color.xyz;
	r2.w = dot(-r6.xyz, r2.xyz);
	r2.w = r2.w + r2.w;
	r6.xyz = r2.xyz * -r2.www + -r6.xyz;
	r2.w = dot(r2.xyz, -gDirectionalLight.xyz);
	r4.z = saturate(dot(-gDirectionalLight.xyz, r6.xyz));
	r4.z = r4.z + 1E-05;
	r4.x = specular2Factor.x * r4.y + r4.x;
	r6.x = pow(r4.z, r4.x);
	r4.x = saturate(r2.w * 2 + -0.5);
	r2.w = (r2.w >= 0) ? r4.x : 0;
	r2.w = r2.w * r6.x;
	r4.xyz = r2.www * r5.yzw;
	r4.xyz = r0.xyz * r4.xyz;
	r4.xyz = r4.xyz * r5.xxx + r1.xyz;
	r1.xyz = (-specular2ColorIntensity.xxx >= 0) ? r1.xyz : r4.xyz;
	o.color2.x = r3.w * matDiffuseColor2.w;
	r2.w = r3.x * matDiffuseColor2.w;
	r1.xyz = r1.xyz * matDiffuseColor2.www;
	r1.w = saturate(r1.w * r3.y + -1);
	o.color.xyz = r1.www * globalScalars2.zzz + r0.xyz;
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.x = saturate(r2.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = r3.z * gAmbientOcclusionEffect.w;
	r0.x = r0.w * globalScalars.x;
	r0.yzw = saturate(r1.xyz * 0.0625);
	r0.y = rsqrt(r0.y);
	r0.z = rsqrt(r0.z);
	r0.w = rsqrt(r0.w);
	o.color3.x = 1 / r0.y;
	o.color3.y = 1 / r0.z;
	o.color3.z = 1 / r0.w;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.w = r0.x;
	o.color3.w = gStencil.x;

	return o;
}
