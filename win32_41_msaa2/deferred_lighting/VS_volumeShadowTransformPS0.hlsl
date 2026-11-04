cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer DeferredLight : register(b4)
{
	float gDeferredLightType : packoffset(c0);
	float3 gDeferredLightPosition : packoffset(c0.y);
	float3 gDeferredLightDirection : packoffset(c1);
	float3 gDeferredLightTangent : packoffset(c2);
	float4 gDeferredLightRadiusProjShearParams : packoffset(c3);
	float gDeferredLightInvSqrRadius : packoffset(c4);
	float gDeferredVolumeRadiusScale : packoffset(c4.y);
	float gDeferredLightConeAngleI : packoffset(c4.z);
	float gDeferredLightConeAngle : packoffset(c4.w);
};

float4 main(float3 position : POSITION) : SV_Position
{
	float4 o;

	int4 r0;
	int4 r1;
	int4 r2;
	float3 r3;
	float3 r4;
	r0.xyz = asint(gDeferredLightDirection.yzx * gDeferredLightTangent.zxy);
	r0.xyz = asint(gDeferredLightTangent.yzx * gDeferredLightDirection.zxy + -(asfloat(r0.xyz)));
	r0.w = (gDeferredLightType == 4) ? -1 : 0;
	if (r0.w != 0) {
		r1.xy = asint(cos(float2(gDeferredLightConeAngle, gDeferredLightConeAngleI)));
		r0.w = asint(-(position.z) * -1.57079637 + 1.57079637);
		r0.w = asint(cos(asfloat(r0.w)));
		r1.z = asint(-(asfloat(r0.w)) * asfloat(r0.w) + 1);
		r1.w = asint(dot(position.xy, position.xy));
		r1.z = asint(asfloat(r1.z) / asfloat(r1.w));
		r1.z = asint(sqrt(asfloat(r1.z)));
		r1.w = (asfloat(r1.x) >= asfloat(r0.w)) ? -1 : 0;
		r2.x = asint(asfloat(r1.z) * gDeferredVolumeRadiusScale);
		r2.xy = asint(asfloat(r2.xx) * position.xy);
		r2.yzw = asint(asfloat(r0.xyz) * asfloat(r2.yyy));
		r2.xyz = asint(gDeferredLightTangent.xyz * asfloat(r2.xxx) + asfloat(r2.yzw));
		r3 = gDeferredLightDirection.xyz * asfloat(r1.xxx) + asfloat(r2.xyz);
		r1.x = (asfloat(r0.w) >= asfloat(r1.y)) ? -1 : 0;
		r2.xyz = asint(gDeferredLightDirection.xyz * asfloat(r1.yyy) + asfloat(r2.xyz));
		r1.yz = asint(asfloat(r1.zz) * position.xy);
		r4 = asfloat(r0.xyz) * asfloat(r1.zzz);
		r4 = gDeferredLightTangent.xyz * asfloat(r1.yyy) + r4.xyz;
		r4 = gDeferredLightDirection.xyz * asfloat(r0.www) + r4.xyz;
		r1.xyz = (r1.xxx != 0) ? r2.xyz : asint(r4.xyz);
		r1.xyz = (r1.www != 0) ? asint(r3.xyz) : r1.xyz;
	} else {
		r0.w = (gDeferredLightType == 2) ? -1 : 0;
		r1.w = asint(dot(position.xy, position.xy));
		r2.x = (asfloat(r1.w) >= 0.0000999999975) ? -1 : 0;
		r2.y = asint(saturate(-(position.z)));
		r2.y = asint(-(asfloat(r2.y)) + 1);
		r2.y = asint(asfloat(r2.y) * gDeferredLightConeAngle);
		r2.y = asint(cos(asfloat(r2.y)));
		r2.z = asint(-(asfloat(r2.y)) * asfloat(r2.y) + 1);
		r1.w = asint(asfloat(r2.z) / asfloat(r1.w));
		r1.w = asint(sqrt(asfloat(r1.w)));
		r1.w = asint(asfloat(r1.w) * gDeferredVolumeRadiusScale);
		r2.zw = asint(asfloat(r1.ww) * position.xy);
		r0.xyz = asint(asfloat(r0.xyz) * asfloat(r2.www));
		r0.xyz = asint(gDeferredLightTangent.xyz * asfloat(r2.zzz) + asfloat(r0.xyz));
		r0.xyz = asint(gDeferredLightDirection.xyz * asfloat(r2.yyy) + asfloat(r0.xyz));
		r1.w = (abs(position.z) >= 0.0000999999975) ? -1 : 0;
		r1.w = r1.w & 1065353216;
		r2.yzw = asint(asfloat(r1.www) * gDeferredLightDirection.xyz);
		r0.xyz = (r2.xxx != 0) ? r0.xyz : r2.yzw;
		r2.xyz = asint(position.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
		r1.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r2.xyz = asint(asfloat(r1.www) * asfloat(r2.xyz));
		r1.xyz = (r0.www != 0) ? r0.xyz : r2.xyz;
	}
	r0.x = asint(gDeferredLightRadiusProjShearParams.x * gDeferredVolumeRadiusScale);
	r0.x = asint(asfloat(r0.x) * 0.662000000);
	r0.xyz = asint(asfloat(r1.xyz) * asfloat(r0.xxx) + gDeferredLightPosition.xyz);
	r1 = asint(asfloat(r0.y) * gWorldViewProj[1]);
	r1 = asint(asfloat(r0.x) * gWorldViewProj[0] + asfloat(r1));
	r0 = asint(asfloat(r0.z) * gWorldViewProj[2] + asfloat(r1));
	o = asfloat(r0) + gWorldViewProj[3];

	return o;
}
