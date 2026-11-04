sampler2D DiffuseSampler : register(s0);
sampler2D DirtSampler : register(s3);
sampler2D DynamicEnvironmentSampler : register(s13);
sampler2D SpecSampler : register(s4);
float3 dirtColor : register(c200);
float dirtLevel : register(c199);
float fresnelRolloff : register(c206);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalFogColorN : register(c50);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c197);
float4 matDiffuseColor2 : register(c198);
float reflectivePower : register(c205);
float4 specMapExpMask : register(c204);
float3 specMapIntMask : register(c203);
float specularColorFactor : register(c202);
float specularFactor : register(c201);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float2 texcoord7 : TEXCOORD7;
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
	r1.yz = float2(1, 0);
	if (-reflectivePower.x < r1.z) {
		r3.xyz = 1E-05 + i.texcoord3.xyz;
		r4.xyz = normalize(r3.xyz);
		r1.w = dot(-r4.xyz, r2.xyz);
		r1.w = r1.w + r1.w;
		r3.xyz = r2.xyz * -r1.www + -r4.xyz;
		r3.xyz = r3.xyz + 1E-05;
		r5.xyz = normalize(r3.xyz);
		r1.w = saturate(r5.z);
		r1.w = r1.w + 1;
		r1.w = r1.w + r1.w;
		r1.w = 1 / r1.w;
		r3.xy = r5.xy * r1.ww + 0.5;
		r3.xy = -r3.xy + 1;
		r3.zw = 0;
		r3 = tex2Dlod(DynamicEnvironmentSampler, r3);
		r3.xyz = r3.xyz * r3.xyz;
		r3.xyz = r3.xyz * 16;
		r1.w = saturate(dot(r4.xyz, r2.xyz));
		r3.w = r1.y + -fresnelRolloff.x;
		r1.w = -r1.w + 1.00001;
		r4.x = pow(r1.w, 5.00001);
		r1.w = fresnelRolloff.x * r4.x + r3.w;
		r3.xyz = r1.www * r3.xyz;
	} else {
		r3.xyz = 0;
	}
	r3.xyz = r3.xyz * reflectivePower.xxx;
	r3.xyz = r3.xyz * globalFogColorN.www;
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r4 = r0 * i.texcoord2;
	r0.x = dot(i.texcoord2.xyz, float3(0.2125, 0.7154, 0.0721));
	r0.z = globalScalars.z;
	r0.y = r0.z * gAmbientOcclusionEffect.y;
	r0.z = r0.y * r0.x;
	if (-dirtLevel.x < r1.z) {
		r5 = tex2D(DirtSampler, i.texcoord7.xy);
		r1.z = r5.x * dirtLevel.x;
		r1.y = r5.x * -dirtLevel.x + r1.y;
		r6.xyz = lerp(r4.xyz, dirtColor.xyz, r1.zzz);
		r6.w = r0.w * i.texcoord2.w + r5.x;
		r4 = (-r5.x >= 0) ? r4 : r6;
		r0.w = (-r5.x >= 0) ? 1 : r1.y;
	} else {
		r0.w = 1;
	}
	r0.w = r0.w * r1.x;
	o.color2.x = r0.w * matDiffuseColor2.w;
	r0.w = r2.w * matDiffuseColor2.w;
	r1.xyz = r3.xyz * matDiffuseColor2.www;
	r0.x = saturate(r0.x * r0.y + -1);
	o.color.xyz = r0.xxx * globalScalars2.zzz + r4.xyz;
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.x = saturate(r0.w * 0.0051020407);
	r0.x = rsqrt(r0.x);
	o.color2.y = 1 / r0.x;
	r0.x = r4.w * globalScalars.x;
	r1.xyz = saturate(r1.xyz * 0.0625);
	r0.y = rsqrt(r1.x);
	r0.w = rsqrt(r1.y);
	r1.x = rsqrt(r1.z);
	o.color3.x = 1 / r0.y;
	o.color3.y = 1 / r0.w;
	o.color3.z = 1 / r1.x;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.zw = r0.zx;
	o.color3.w = gStencil.x;

	return o;
}
