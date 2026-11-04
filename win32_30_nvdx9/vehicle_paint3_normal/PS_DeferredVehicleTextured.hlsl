sampler2D BumpSampler : register(s4);
sampler2D DiffuseSampler : register(s0);
sampler2D DiffuseSampler2 : register(s2);
sampler2D DirtSampler : register(s3);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D SpecSampler : register(s5);
float bumpiness : register(c209);
float3 dirtColor : register(c200);
float dirtLevel : register(c199);
float fresnelRolloff : register(c211);
float4 gAmbientOcclusionEffect : register(c63);
float4 gDirectionalLight : register(c19);
float4 gStencil : register(c61);
float4 globalFogColorN : register(c50);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c197);
float4 matDiffuseColor2 : register(c198);
float reflectivePower : register(c210);
float4 specMapExpMask : register(c204);
float3 specMapIntMask : register(c203);
float3 specMapReflectMask : register(c212);
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
	float4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	r0 = tex2D(BumpSampler, i.texcoord.xy);
	r0.z = -r0.w + 1;
	r0.z = -r0.x + r0.z;
	r0.xy = (r0.zz >= 0) ? r0.wy : r0.xy;
	r1 = tex2D(DiffuseSampler, i.texcoord.xy);
	r2 = tex2D(DiffuseSampler2, i.texcoord.zw);
	r0.xy = r0.xy * 2 + -1;
	r0.xy = r0.xy * bumpiness.xx;
	r0.z = dot(r0.xy, -r0.xy) + 1;
	r3.x = max(r0.z, 0);
	r0.z = rsqrt(r3.x);
	r0.z = 1 / r0.z;
	r3 = tex2D(SpecSampler, i.texcoord.zw);
	r0.w = dot(r3, specMapExpMask);
	r0.w = r0.w * specularFactor.x;
	r3.w = dot(r3.xyz, specMapIntMask.xyz);
	r3.w = r3.w * specularColorFactor.x;
	r4.x = max(1, r0.w);
	r4.yzw = r0.xxx * i.texcoord4.xyz;
	r0.xzw = r0.zzz * i.texcoord1.xyz + r4.yzw;
	r0.xyz = r0.yyy * i.texcoord5.xyz + r0.xzw;
	r0.xyz = r0.xyz + 1E-05;
	r5.xyz = normalize(r0.xyz);
	r0.xw = float2(1, 0);
	if (-reflectivePower.x < r0.w) {
		r4.yzw = 1E-05 + i.texcoord3.xyz;
		r6.xyz = normalize(r4.yzw);
		r0.y = dot(-r6.xyz, r5.xyz);
		r0.y = r0.y + r0.y;
		r4.yzw = r5.xyz * -r0.yyy + -r6.xyz;
		r4.yzw = r4.yzw + 1E-05;
		r7.xyz = normalize(r4.yzw);
		r0.y = saturate(r7.z);
		r0.y = r0.y + 1;
		r0.y = r0.y + r0.y;
		r0.y = 1 / r0.y;
		r0.yz = r7.xy * r0.yy + 0.5;
		r7.xy = -r0.yz + 1;
		r7.zw = 0;
		r7 = tex2Dlod(DynamicEnvironmentSampler, r7);
		r4.yzw = r7.xyz * r7.xyz;
		r4.yzw = r4.yzw * 16;
		r0.y = saturate(dot(r6.xyz, r5.xyz));
		r0.z = r0.x + -fresnelRolloff.x;
		r0.y = -r0.y + 1.00001;
		r5.w = r0.y * r0.y;
		r5.w = r5.w * r5.w;
		r0.y = r0.y * r5.w;
		r0.y = fresnelRolloff.x * r0.y + r0.z;
		r4.yzw = r0.yyy * r4.yzw;
	} else {
		r4.yzw = 0;
	}
	r4.yzw = r4.yzw * reflectivePower.xxx;
	r0.y = dot(r3.xyz, specMapReflectMask.xyz);
	r3.xyz = r0.yyy * r4.yzw;
	r3.xyz = r3.xyz * globalFogColorN.www;
	r4.yzw = r1.xyz * matDiffuseColor.xyz;
	r0.y = r2.w * matDiffuseColor2.w;
	r2.xyz = r2.xyz * matDiffuseColor2.xyz + -r4.yzw;
	r1.xyz = r0.yyy * r2.xyz + r4.yzw;
	r1 = r1 * i.texcoord2;
	r0.y = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.z = globalScalars.z;
	r0.z = r0.z * gAmbientOcclusionEffect.y;
	r2.x = r0.z * r0.y;
	if (-dirtLevel.x < r0.w) {
		r6 = tex2D(DirtSampler, i.texcoord.xy);
		r0.w = r6.x * dirtLevel.x;
		r7.x = r6.x * -dirtLevel.x + r0.x;
		r7.yzw = lerp(r1.xyz, dirtColor.xyz, r0.www);
		r8 = r1.xxyz * float4(0, 1, 1, 1) + float4(1, 0, 0, 0);
		r6 = (-r6.x >= 0) ? r8 : r7;
		r1.xyz = r6.yzw;
	} else {
		r6.x = 1;
	}
	r0.x = r3.w * r6.x;
	r0.w = 1 / specularFactor.x;
	r0.w = r0.w * r4.x;
	r2.y = 1 / specularColorFactor.x;
	r2.y = r2.y * r3.w;
	r2.z = specular2ColorIntensity.x * specular2ColorIntensity.x;
	r2.y = r2.z * r2.y;
	r4.yzw = 1E-05 + i.texcoord3.xyz;
	r7.xyz = normalize(r4.yzw);
	r2.yzw = r2.yyy * specular2Color.xyz;
	r3.w = dot(-r7.xyz, r5.xyz);
	r3.w = r3.w + r3.w;
	r4.yzw = r5.xyz * -r3.www + -r7.xyz;
	r3.w = dot(r5.xyz, -gDirectionalLight.xyz);
	r4.y = saturate(dot(-gDirectionalLight.xyz, r4.yzw));
	r4.y = r4.y + 1E-05;
	r7.x = 1E-05;
	r0.w = specular2Factor.x * r0.w + r7.x;
	r5.w = pow(r4.y, r0.w);
	r0.w = saturate(r3.w * 2 + -0.5);
	r0.w = (r3.w >= 0) ? r0.w : 0;
	r0.w = r0.w * r5.w;
	r2.yzw = r0.www * r2.yzw;
	r2.yzw = r1.xyz * r2.yzw;
	r2.yzw = r2.yzw * r6.xxx + r3.xyz;
	r2.yzw = (-specular2ColorIntensity.xxx >= 0) ? r3.xyz : r2.yzw;
	o.color2.x = r0.x * matDiffuseColor2.w;
	r0.x = r4.x * matDiffuseColor2.w;
	r2.yzw = r2.yzw * matDiffuseColor2.www;
	r0.y = saturate(r0.y * r0.z + -1);
	o.color.xyz = r0.yyy * globalScalars2.zzz + r1.xyz;
	o.color1.xyz = r5.xyz * 0.5 + 0.5;
	r0.x = saturate(r0.x * 0.0051020407);
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	o.color2.z = r2.x * gAmbientOcclusionEffect.w;
	r0.x = r1.w * globalScalars.x;
	r0.yzw = saturate(r2.yzw * 0.0625);
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
