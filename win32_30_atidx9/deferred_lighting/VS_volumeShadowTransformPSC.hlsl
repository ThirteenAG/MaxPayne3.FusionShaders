float gDeferredLightConeAngle : register(c211);
float gDeferredLightConeAngleI : register(c210);
float3 gDeferredLightDirection : register(c204);
float3 gDeferredLightPosition : register(c203);
float gDeferredLightRadius : register(c206);
float3 gDeferredLightTangent : register(c205);
float gDeferredLightType : register(c202);
float gDeferredVolumeRadiusScale : register(c209);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	float3 r3;
	float3 r4;
	r0.xyz = gDeferredLightDirection.xyz;
	r1.xyz = r0.yzx * gDeferredLightTangent.zxy;
	r0.xyz = gDeferredLightTangent.yzx * r0.zxy + -r1.xyz;
	r1 = float4(-4, 0.15915494, 0.5, -2);
	r0.w = r1.x + gDeferredLightType.x;
	if (-abs(r0.w) >= abs(r0.w)) {
		r0.w = gDeferredLightConeAngle.x * r1.y + r1.z;
		r0.w = frac(r0.w);
		r0.w = r0.w * 6.2831855 + -3.1415927;
		r2.x = cos(r0.w);
		r0.w = gDeferredLightConeAngleI.x * r1.y + r1.z;
		r0.w = frac(r0.w);
		r0.w = r0.w * 6.2831855 + -3.1415927;
		r3.x = cos(r0.w);
		r0.w = position.z * 1.5707964 + 1.5707964;
		r0.w = r0.w * 0.15915494 + 0.5;
		r0.w = frac(r0.w);
		r0.w = r0.w * 6.2831855 + -3.1415927;
		r4.x = cos(r0.w);
		r0.w = (r2.x >= r4.x) ? 1 : 0;
		r1.xy = gDeferredVolumeRadiusScale.xx * position.xy;
		r2.yzw = r0.xyz * r1.yyy;
		r1.xyz = gDeferredLightTangent.xyz * r1.xxx + r2.yzw;
		r2.xyz = gDeferredLightDirection.xyz * r2.xxx + r1.xyz;
		r2.w = (r4.x >= r3.x) ? 1 : 0;
		r1.xyz = gDeferredLightDirection.xyz * r3.xxx + r1.xyz;
		r3 = r0.xyz * position.yyy;
		r3 = gDeferredLightTangent.xyz * position.xxx + r3.xyz;
		r3 = gDeferredLightDirection.xyz * r4.xxx + r3.xyz;
		r4 = lerp(r3.xyz, r1.xyz, r2.www);
		r1.xyz = lerp(r4.xyz, r2.xyz, r0.www);
	} else {
		r0.w = r1.w + gDeferredLightType.x;
		r0.w = (-abs(r0.w) >= abs(r0.w)) ? 1 : 0;
		r2.xy = position.xy * position.xy;
		r1.w = r2.y + r2.x;
		r1.w = (r1.w >= 0.0001) ? 1 : 0;
		r2.x = saturate(-position.z);
		r2.x = -r2.x + 1;
		r2.x = r2.x * gDeferredLightConeAngle.x;
		r2.x = r2.x * 0.15915494 + 0.5;
		r2.x = frac(r2.x);
		r2.x = r2.x * 6.2831855 + -3.1415927;
		r3.x = cos(r2.x);
		r2.xy = gDeferredVolumeRadiusScale.xx * position.xy;
		r0.xyz = r0.xyz * r2.yyy;
		r0.xyz = gDeferredLightTangent.xyz * r2.xxx + r0.xyz;
		r0.xyz = gDeferredLightDirection.xyz * r3.xxx + r0.xyz;
		r2.x = (abs(position.z) >= 0.0001) ? 1 : 0;
		r2.yzw = r2.xxx * gDeferredLightDirection.xyz;
		r0.xyz = gDeferredLightDirection.xyz * -r2.xxx + r0.xyz;
		r0.xyz = r1.www * r0.xyz + r2.yzw;
		r2.xyz = 1E-05 + position.xyz;
		r1.w = dot(r2.xyz, r2.xyz);
		r1.w = rsqrt(r1.w);
		r3 = r1.www * r2.xyz;
		r0.xyz = r2.xyz * -r1.www + r0.xyz;
		r1.xyz = r0.www * r0.xyz + r3.xyz;
	}
	r0.x = gDeferredVolumeRadiusScale.x;
	r0.x = r0.x * gDeferredLightRadius.x;
	r0.x = r0.x * 0.662;
	r0.xyz = r1.xyz * r0.xxx + gDeferredLightPosition.xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r0 = r0.z * gWorldViewProj[2] + r1;
	o.position = r0 + gWorldViewProj[3];
	o.texcoord = 1;

	return o;
}
