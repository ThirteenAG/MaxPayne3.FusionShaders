sampler2D DiffuseSampler : register(s0);
sampler2D DiffuseSampler2 : register(s2);
sampler2D DirtSampler : register(s3);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D SpecSampler : register(s4);
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
	float4 texcoord : TEXCOORD;
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
	float4 r8;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r1 = tex2D(DiffuseSampler2, i.texcoord.zw);
	r2.xyz = 1E-05 + i.texcoord1.xyz;
	r3.xyz = normalize(r2.xyz);
	r2 = tex2D(SpecSampler, i.texcoord.zw);
	r2.w = dot(r2, specMapExpMask);
	r2.w = r2.w * specularFactor.x;
	r3.w = dot(r2.xyz, specMapIntMask.xyz);
	r3.w = r3.w * specularColorFactor.x;
	r4.x = max(1, r2.w);
	r5.xyz = float3(1E-05, 1, 0);
	if (-reflectivePower.x < r5.z) {
		r4.yzw = 1E-05 + i.texcoord3.xyz;
		r6.xyz = normalize(r4.yzw);
		r2.w = dot(-r6.xyz, r3.xyz);
		r2.w = r2.w + r2.w;
		r4.yzw = r3.xyz * -r2.www + -r6.xyz;
		r4.yzw = r4.yzw + 1E-05;
		r7.xyz = normalize(r4.yzw);
		r2.w = saturate(r7.z);
		r2.w = r2.w + 1;
		r2.w = r2.w + r2.w;
		r2.w = 1 / r2.w;
		r4.yz = r7.xy * r2.ww + 0.5;
		r7.xy = -r4.yz + 1;
		r7.zw = 0;
		r7 = tex2Dlod(DynamicEnvironmentSampler, r7);
		r4.yzw = r7.xyz * r7.xyz;
		r4.yzw = r4.yzw * 16;
		r2.w = saturate(dot(r6.xyz, r3.xyz));
		r5.w = r5.y + -fresnelRolloff.x;
		r2.w = -r2.w + 1.00001;
		r6.x = r2.w * r2.w;
		r6.x = r6.x * r6.x;
		r2.w = r2.w * r6.x;
		r2.w = fresnelRolloff.x * r2.w + r5.w;
		r4.yzw = r2.www * r4.yzw;
	} else {
		r4.yzw = 0;
	}
	r4.yzw = r4.yzw * reflectivePower.xxx;
	r2.x = dot(r2.xyz, specMapReflectMask.xyz);
	r2.xyz = r2.xxx * r4.yzw;
	r2.xyz = r2.xyz * globalFogColorN.www;
	r4.yzw = r0.xyz * matDiffuseColor.xyz;
	r1.w = r1.w * matDiffuseColor2.w;
	r1.xyz = r1.xyz * matDiffuseColor2.xyz + -r4.yzw;
	r0.xyz = r1.www * r1.xyz + r4.yzw;
	r0 = r0 * i.texcoord2;
	r1.x = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r1.z = globalScalars.z;
	r1.y = r1.z * gAmbientOcclusionEffect.y;
	r1.z = r1.y * r1.x;
	if (-dirtLevel.x < r5.z) {
		r6 = tex2D(DirtSampler, i.texcoord.xy);
		r1.w = r6.x * dirtLevel.x;
		r7.x = r6.x * -dirtLevel.x + r5.y;
		r7.yzw = lerp(r0.xyz, dirtColor.xyz, r1.www);
		r8 = r0.xxyz * float4(0, 1, 1, 1) + float4(1, 0, 0, 0);
		r6 = (-r6.x >= 0) ? r8 : r7;
		r0.xyz = r6.yzw;
	} else {
		r6.x = 1;
	}
	r1.w = r3.w * r6.x;
	r2.w = 1 / specularFactor.x;
	r2.w = r2.w * r4.x;
	r4.y = 1 / specularColorFactor.x;
	r3.w = r3.w * r4.y;
	r4.y = specular2ColorIntensity.x * specular2ColorIntensity.x;
	r3.w = r3.w * r4.y;
	r4.yzw = 1E-05 + i.texcoord3.xyz;
	r7.xyz = normalize(r4.yzw);
	r4.yzw = r3.www * specular2Color.xyz;
	r3.w = dot(-r7.xyz, r3.xyz);
	r3.w = r3.w + r3.w;
	r5.yzw = r3.xyz * -r3.www + -r7.xyz;
	r3.w = dot(r3.xyz, -gDirectionalLight.xyz);
	r5.y = saturate(dot(-gDirectionalLight.xyz, r5.yzw));
	r5.y = r5.y + 1E-05;
	r2.w = specular2Factor.x * r2.w + r5.x;
	r6.y = pow(r5.y, r2.w);
	r2.w = saturate(r3.w * 2 + -0.5);
	r2.w = (r3.w >= 0) ? r2.w : 0;
	r2.w = r2.w * r6.y;
	r4.yzw = r2.www * r4.yzw;
	r4.yzw = r0.xyz * r4.yzw;
	r4.yzw = r4.yzw * r6.xxx + r2.xyz;
	r2.xyz = (-specular2ColorIntensity.xxx >= 0) ? r2.xyz : r4.yzw;
	o.color2.x = r1.w * matDiffuseColor2.w;
	r1.w = r4.x * matDiffuseColor2.w;
	r2.xyz = r2.xyz * matDiffuseColor2.www;
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
	r0.yzw = saturate(r2.xyz * 0.0625);
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
