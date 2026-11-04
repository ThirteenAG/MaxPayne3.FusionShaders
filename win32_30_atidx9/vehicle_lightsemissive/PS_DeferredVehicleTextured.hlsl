sampler2D DiffuseSampler : register(s0);
sampler2D DirtSampler : register(s2);
sampler2D EnvironmentSampler : register(s4);
sampler2D SpecSampler : register(s3);
float3 dirtColor : register(c201);
float dirtLevel : register(c200);
float fresnelRolloff : register(c207);
float4 gAmbientOcclusionEffect : register(c63);
float4 gStencil : register(c61);
float4 globalFogColorN : register(c50);
float4 globalScalars : register(c35);
float4 globalScalars2 : register(c36);
float3 matDiffuseColor : register(c197);
float4 matDiffuseColor2 : register(c198);
float reflectivePower : register(c206);
float4 specMapExpMask : register(c205);
float3 specMapIntMask : register(c204);
float specularColorFactor : register(c203);
float specularFactor : register(c202);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float2 texcoord7 : TEXCOORD7;
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
	r1.x = dot(r1.xyz, specMapIntMask.xyz);
	r1.x = saturate(r1.x * specularColorFactor.x);
	r2.w = max(1, r1.w);
	r1.yzw = 1E-05 + i.texcoord3.xyz;
	r3.xyz = normalize(r1.yzw);
	r1.y = dot(-r3.xyz, r2.xyz);
	r1.y = r1.y + r1.y;
	r1.yzw = r2.xyz * -r1.yyy + -r3.xyz;
	r1.yzw = r1.yzw + 1E-05;
	r4.xyz = normalize(r1.yzw);
	r1.y = saturate(r4.z);
	r1.y = r1.y + 1;
	r1.y = r1.y + r1.y;
	r1.y = 1 / r1.y;
	r1.yz = r4.xy * r1.yy + 0.5;
	r4.xy = -r1.yz + 1;
	r4.zw = 0;
	r4 = tex2Dlod(EnvironmentSampler, r4);
	r1.yzw = r4.xyz * r4.xyz;
	r1.yzw = r1.yzw * 16;
	r3.x = saturate(dot(r3.xyz, r2.xyz));
	r3.yw = float2(1, 0);
	r3.z = r3.y + -fresnelRolloff.x;
	r3.x = -r3.x + 1.00001;
	r4.x = pow(r3.x, 5.00001);
	r3.x = fresnelRolloff.x * r4.x + r3.z;
	r1.yzw = r1.yzw * r3.xxx;
	r1.yzw = r1.yzw * reflectivePower.xxx;
	r1.yzw = r1.yzw * globalFogColorN.www;
	r4.xyz = r0.xyz * matDiffuseColor.xyz;
	r0.x = r0.w;
	r0.x = r0.x * i.texcoord2.w;
	r0.z = globalScalars.z;
	r0.y = r0.z * gAmbientOcclusionEffect.y;
	if (-dirtLevel.x < r3.w) {
		r5 = tex2D(DirtSampler, i.texcoord7.xy);
		r0.w = r5.x * dirtLevel.x;
		r6.x = r5.x * -dirtLevel.x + r3.y;
		r6.yzw = lerp(r4.xyz, dirtColor.xyz, r0.www);
		r7 = r4.xxyz * float4(0, 1, 1, 1) + float4(1, 0, 0, 0);
		r4 = (-r5.x >= 0) ? r7.yzwx : r6.yzwx;
	} else {
		r4.w = 1;
	}
	r0.w = r1.x * r4.w;
	o.color2.x = r0.w * matDiffuseColor2.w;
	r0.w = r2.w * matDiffuseColor2.w;
	r1.xyz = r1.yzw * matDiffuseColor2.www;
	r0.z = saturate(r0.z * gAmbientOcclusionEffect.y + -r3.y);
	o.color.xyz = r0.zzz * globalScalars2.zzz + r4.xyz;
	o.color1.xyz = r2.xyz * 0.5 + 0.5;
	r0.z = saturate(r0.w * 0.0051020407);
	r0.z = rsqrt(r0.z);
	o.color2.y = 1 / r0.z;
	r0.x = r0.x * globalScalars.x;
	r1.xyz = saturate(r1.xyz * 0.0625);
	r0.z = rsqrt(r1.x);
	r0.w = rsqrt(r1.y);
	r1.x = rsqrt(r1.z);
	o.color3.x = 1 / r0.z;
	o.color3.y = 1 / r0.w;
	o.color3.z = 1 / r1.x;
	o.color.w = r0.x;
	o.color1.w = r0.x;
	o.color2.zw = r0.yx;
	o.color3.w = gStencil.x;

	return o;
}
