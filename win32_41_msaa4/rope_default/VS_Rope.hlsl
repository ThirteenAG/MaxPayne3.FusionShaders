cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer direction_light : register(b10)
{
	float4 gDepthFxParams : packoffset(c0);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
};

cbuffer RopeData : register(b4)
{
	float SegmentSize : packoffset(c0);
	float radius : packoffset(c0.y);
	float3 uvScales : packoffset(c1);
	float4 ropeColor : packoffset(c2);
	float4 curveCoeffs[57] : packoffset(c3);
	float4 approxTangent[20] : packoffset(c60);
};

struct VS_IN
{
	float3 sv_position : SV_Position;
	float3 normal : NORMAL;
	float3 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord9 : TEXCOORD9;
	float sv_clipdistance : SV_ClipDistance;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float t0 = i.sv_position.y * SegmentSize;
	float t1 = t0;
	float t2 = t0 - trunc(t1);
	int t3 = (int)t1;
	float3 t4 = approxTangent[t3].xyz * (1 - t2) + t2 * approxTangent[t3 + 1].xyz;
	float t5 = t2 * t2;
	int t6 = 3 * t3 + 1;
	float t7 = dot(curveCoeffs[t6], float4(1, t2, t5, t2 * t5));
	int t8 = 3 * t3 + 2;
	float t9 = dot(curveCoeffs[t8], float4(1, t2, t5, t2 * t5));
	float t10 = t2 + 0.00100000005;
	float t11 = t2 + 0.00100000005;
	float t12 = t11 * t11;
	float t13 = t11 * t12;
	int t14 = 3 * t3;
	float t15 = dot(curveCoeffs[t14], float4(1, t2, t5, t2 * t5));
	float3 t16 = float3(curveCoeffs[t14].x + curveCoeffs[t14].y * t10 + curveCoeffs[t14].z * t12 + curveCoeffs[t14].w * t13 - t15, curveCoeffs[t6].x + curveCoeffs[t6].y * t10 + curveCoeffs[t6].z * t12 + curveCoeffs[t6].w * t13 - t7, curveCoeffs[t8].x + curveCoeffs[t8].y * t10 + curveCoeffs[t8].z * t12 + curveCoeffs[t8].w * t13 - t9);
	float3 t17 = normalize(t16);
	float3 t18 = cross(t17, t4);
	float3 t19 = normalize(t18);
	float3 t20 = cross(t19, t17);
	float3 t21 = normalize(t20);
	float3 t22 = t21 * i.texcoord.x + t19 * i.texcoord.z + t17 * i.texcoord.y;
	float3 t23 = mul(t22, (float3x3)gWorld);
	float3 t24 = t21 * i.normal.x + t19 * i.normal.z + t17 * i.normal.y;
	float3 t25 = mul(t24, (float3x3)gWorld);
	float3 t26 = t21 * i.sv_position.x * radius + t19 * i.sv_position.z * radius + float3(t15, t7, t9);
	float t27 = dot(float4(gWorld[0].z, gWorld[1].z, gWorld[2].z, gWorld[3].z), float4(t26, 1)) - gViewInverse[3].z;
	float t28 = t27 * globalFogParams.x;
	float t29 = length(float3(mul(float4(t26, 1), (float4x2)gWorld) - gViewInverse[3].xy, t27)) * globalFogParams.z;
	float4 t30 = mul(float4(t26, 1), gWorldViewProj);
	o.sv_position = t30;
	o.color = float4(ropeColor.xyz, 1);
	o.texcoord = i.texcoord1 * uvScales.xy;
	o.texcoord1 = float4(normalize(t25), dot(float4(gWorldViewProj[0].w, gWorldViewProj[1].w, gWorldViewProj[2].w, gWorldViewProj[3].w), float4(t26, 1)));
	o.texcoord3 = normalize(gViewInverse[3].xyz - mul(float4(t26, 1), (float4x3)gWorld));
	o.texcoord4 = normalize(t23);
	o.texcoord5 = normalize(cross(normalize(t25), normalize(t23)));
	o.texcoord6 = float4(mul(float4(t26, 1), (float4x3)gWorld), 1);
	o.texcoord9 = float4(1 - exp((abs(t28) > 0.0000999999975 ? (1 - exp2(-1.44269502 * t28)) / t28 * t29 : t29) * -globalFogParams.y), lerp(saturate(-t30.w * gDepthFxParams.z + gDepthFxParams.w), 1, gDepthFxParams.y) - 1, 0, 0);
	o.sv_clipdistance = -1;

	return o;
}
