float4 gDeferredLightColourAndIntensity : register(c214);
float gDeferredLightConeAngle : register(c211);
float3 gDeferredLightDirection : register(c204);
float3 gDeferredLightPosition : register(c203);
float4 gDeferredLightRadiusProjShearParams : register(c206);
float3 gDeferredLightTangent : register(c205);
float4 gDeferredLightVolumeParams : register(c218);
float gDeferredVolumeRadiusScale : register(c209);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	float3 r4;
	r0.w = gDeferredLightColourAndIntensity.w;
	r0.x = r0.w * gDeferredLightVolumeParams.x;
	r0.x = r0.x * 0.25;
	o.texcoord2.xyz = r0.xxx * gDeferredLightColourAndIntensity.xyz;
	r0.x = saturate(-position.z);
	r0.x = -r0.x + 1;
	r0.x = r0.x * gDeferredLightConeAngle.x;
	r0.x = r0.x * 0.15915494 + 0.5;
	r0.x = frac(r0.x);
	r0.x = r0.x * 6.2831855 + -3.1415927;
	r1.x = cos(r0.x);
	r0.x = r1.x * -r1.x + 1;
	r0.yz = position.xy * position.xy;
	r0.y = r0.z + r0.y;
	r0.z = 1 / r0.y;
	r0.y = (r0.y >= 0.0001) ? 1 : 0;
	r0.x = r0.z * r0.x;
	r0.x = rsqrt(r0.x);
	r0.x = 1 / r0.x;
	r2.x = 0.98;
	r0.z = min(r2.x, gDeferredVolumeRadiusScale.x);
	r0.x = r0.z * r0.x;
	r0.z = r0.z * gDeferredLightRadiusProjShearParams.x;
	r2.w = r0.z * 0.662;
	r0.xz = r0.xx * position.xy;
	r3 = gDeferredLightDirection.xyz;
	r1.yzw = r3.yzx * gDeferredLightTangent.zxy;
	r1.yzw = gDeferredLightTangent.yzx * r3.zxy + -r1.yzw;
	r1.yzw = r0.zzz * r1.yzw;
	r0.xzw = gDeferredLightTangent.xyz * r0.xxx + r1.yzw;
	r0.xzw = gDeferredLightDirection.xyz * r1.xxx + r0.xzw;
	r1.x = (abs(position.z) >= 0.0001) ? 1 : 0;
	r0.xzw = gDeferredLightDirection.xyz * -r1.xxx + r0.xzw;
	r1.xyz = r1.xxx * gDeferredLightDirection.xyz;
	r0.xyz = r0.yyy * r0.xzw + r1.xyz;
	r1.xyz = r2.www * r0.xyz;
	r0.xyz = r0.xyz * r2.www + gDeferredLightPosition.xyz;
	r0.w = dot(r1.xyz, r1.xyz);
	r0.w = rsqrt(r0.w);
	r0.w = 1 / r0.w;
	r0.w = r0.w + 1E-05;
	o.texcoord4.xyz = r3.xyz * r0.www + gDeferredLightPosition.xyz;
	o.texcoord2.w = r0.w;
	r1.xyz = gDeferredLightPosition.xyz;
	r1.xyz = -r1.xyz + gViewInverse[3].xyz;
	r3 = r1.xyz + 1E-05;
	r4 = normalize(r3.xyz);
	r0.w = dot(gDeferredLightDirection.xyz, r4.xyz);
	r0.w = abs(r0.w) + 1E-05;
	r0.w = log2(r0.w);
	r0.w = r0.w * 2.50001;
	o.texcoord4.w = exp2(r0.w);
	r2.xyz = r0.xyz + -gViewInverse[3].xyz;
	o.texcoord5.xyz = -r2.xyz;
	o.texcoord1 = r2;
	r2 = r0.y * gWorldViewProj[1];
	r2 = r0.x * gWorldViewProj[0] + r2;
	r2 = r0.z * gWorldViewProj[2] + r2;
	o.texcoord3 = r0.xyz;
	r0 = r2 + gWorldViewProj[3];
	o.position = r0;
	r1.w = r0.w;
	o.texcoord = r1;
	o.texcoord5.w = r1.w;

	return o;
}
