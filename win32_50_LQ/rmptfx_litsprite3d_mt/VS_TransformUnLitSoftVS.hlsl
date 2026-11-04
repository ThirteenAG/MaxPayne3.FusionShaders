cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer rage_ptx : register(b3)
{
	float4 gForcedColor : packoffset(c0);
	float4 gAspectRatio : packoffset(c1);
};

cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
	float4 globalScalars2 : packoffset(c1);
	float4 globalScalars3 : packoffset(c2);
	float4 globalScalars4 : packoffset(c3);
	float4 globalFogParams : packoffset(c4);
	float4 globalFogColor : packoffset(c5);
	float4 globalFogOffsetN : packoffset(c6);
	float4 globalFogColorN : packoffset(c7);
};

cbuffer CacheHybrid : register(b4)
{
	float HybridAdd : packoffset(c0);
};

cbuffer CustomVertexVariables : register(b7)
{
	float HybridAddRatio : packoffset(c0);
	float HDRIntensityMultiplier : packoffset(c0.y);
	float4 gActiveUnit : packoffset(c1);
};

cbuffer ParticleSprite : register(b8)
{
	float gBiasToCamera : packoffset(c0);
	float gWrapScale : packoffset(c0.y);
	float gWrapBias : packoffset(c0.z);
	float gDiffuse : packoffset(c0.w);
	float gSpecularIntensity : packoffset(c1);
	float gSpecularExponent : packoffset(c1.y);
	float gExtraLights : packoffset(c1.z);
	float gAmbientAmount : packoffset(c1.w);
	float gSuperAlpha : packoffset(c2);
	float gNormalArc : packoffset(c2.y);
	float gScaleFade : packoffset(c2.z);
	float gUseShadows : packoffset(c2.w);
	float gAmbientShadow : packoffset(c3);
	float gLightIntensityClamp : packoffset(c3.y);
	float4 gTextureAngleRads : packoffset(c4);
	float4 gInterpolationFactor : packoffset(c5);
	float4 gPositionOffset : packoffset(c6);
	float4 gPositionScale : packoffset(c7);
};

struct VS_IN
{
	float3 position : POSITION;
	float4 normal : NORMAL;
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord7 : TEXCOORD7;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord6 : TEXCOORD6;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	float4 r1;
	float4 r2;
	float4 r3;
	float r4;
	r0.x = asint(abs(gViewInverse[2].z) * -0.0187292993 + 0.0742610022);
	r0.x = asint(asfloat(r0.x) * abs(gViewInverse[2].z) + -0.212114394);
	r0.x = asint(asfloat(r0.x) * abs(gViewInverse[2].z) + 1.57072878);
	r0.y = asint(-(abs(gViewInverse[2].z)) + 1);
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.z = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.z = asint(asfloat(r0.z) * -2 + 3.14159274);
	r0.w = (gViewInverse[2].z < -(gViewInverse[2].z)) ? -1 : 0;
	r0.z = r0.w & r0.z;
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y) + asfloat(r0.z));
	r0.x = asint(-(asfloat(r0.x)) + 1.57079637);
	r0 = asint(abs(asfloat(r0.x)) + -(gTextureAngleRads));
	r0 = asint(cos(asfloat(r0)));
	r0 = asint(abs(asfloat(r0)) + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0 = asint(log2(asfloat(r0)));
	r1 = gInterpolationFactor + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0 = asint(asfloat(r0) * r1);
	r0 = asint(exp2(asfloat(r0)));
	r0 = asint(asfloat(r0) * gActiveUnit + float4(0.00000999999975, 0.00000999999975, 0.00000999999975, 0.00000999999975));
	r1.x = dot(asfloat(r0), asfloat(r0));
	r1.x = rsqrt(r1.x);
	r0 = asint(asfloat(r0) * r1.x);
	r1.z = dot(asfloat(r0), gPositionOffset);
	r1.xy = float2(0, 0);
	r2.xyz = -(i.position.xyz) + gViewInverse[3].xyz;
	r1.w = gBiasToCamera * 0.100000001;
	r2.xyz = r2.xyz * r1.www + i.position.xyz;
	r1.xyz = r1.xyz + r2.xyz;
	r3 = r1.y * gWorldViewProj[1];
	r3 = r1.x * gWorldViewProj[0] + r3;
	r1 = r1.z * gWorldViewProj[2] + r3;
	r1 = r1 + gWorldViewProj[3];
	r2.w = dot(asfloat(r0), gPositionScale);
	o.texcoord6 = asfloat(r0);
	r0.xy = asint(r2.ww * i.normal.yx);
	r3.x = sin(i.normal.z);
	r4 = cos(i.normal.z);
	r0.zw = asint(asfloat(r0.xy) * r3.xx);
	r3.x = asfloat(r0.y) * r4.x + -(asfloat(r0.z));
	r3.y = asfloat(r0.x) * r4.x + asfloat(r0.w);
	r3.zw = float2(0, 0);
	o.sv_position = r3 * gAspectRatio + r1;
	r0.x = asint(i.texcoord3.y * globalScalars4.x);
	o.texcoord.xyz = asfloat(r0.xxx) * i.color.xyz;
	o.texcoord.w = saturate(i.color.w * gSuperAlpha);
	r0 = asint(r2.y * gWorldView[1]);
	r0 = asint(r2.x * gWorldView[0] + asfloat(r0));
	r0 = asint(r2.z * gWorldView[2] + asfloat(r0));
	r1.xyz = r2.xyz + -(gViewInverse[3].xyz);
	o.texcoord7 = asfloat(r0) + gWorldView[3];
	o.texcoord1 = i.texcoord;
	r0.x = asint(-(i.texcoord3.x) + 1);
	r0.y = (0.5 < HybridAdd) ? -1 : 0;
	o.texcoord3.z = (r0.y != 0) ? asfloat(r0.x) : 1;
	o.texcoord3.x = i.texcoord2.z;
	o.texcoord3.y = 0;
	o.texcoord3.w = i.texcoord3.y;
	r0.x = asint(r1.z * globalFogParams.x);
	r0.y = asint(dot(r1.xyz, r1.xyz));
	r0.y = asint(sqrt(asfloat(r0.y)));
	r0.y = asint(asfloat(r0.y) * globalFogParams.z);
	r0.z = asint(asfloat(r0.x) * -1.44269502);
	r0.z = asint(exp2(asfloat(r0.z)));
	r0.z = asint(-(asfloat(r0.z)) + 1);
	r0.z = asint(asfloat(r0.z) / asfloat(r0.x));
	r0.x = (0.0000999999975 < abs(asfloat(r0.x))) ? -1 : 0;
	r0.z = asint(asfloat(r0.z) * asfloat(r0.y));
	r0.x = (r0.x != 0) ? r0.z : r0.y;
	r0.x = asint(asfloat(r0.x) * -(globalFogParams.y));
	r0.x = asint(asfloat(r0.x) * 1.44269502);
	r0.x = asint(exp2(asfloat(r0.x)));
	o.texcoord4.w = -(asfloat(r0.x)) + 1;
	o.texcoord4.xyz = globalFogColorN.xyz;

	return o;
}
