cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
	float gDeferredLightConeOffset : packoffset(c5);
	float gDeferredLightConeScale : packoffset(c5.y);
	float4 gDeferredLightColourAndIntensity : packoffset(c6);
	float4 gooDeferredLightScreenSize : packoffset(c7);
	float4 gDeferredProjParams : packoffset(c8);
};

SamplerState gDeferredLightSampler : register(s0);
SamplerState StereoParmsTex : register(s9);
Texture2D gDeferredLightSampler_tex : register(t0);
Texture2D gbufferTexture0 : register(t8);
Texture2D StereoParmsTex_tex : register(t9);
Texture2D<float> gbufferTextureDepth : register(t11);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw));
	r1.yzw = asint(float3(0, 0, 1));
	r2 = asint(gbufferTexture0.Load(r0.xyw));
	r3 = gbufferTexture2.Load(r0.xyw);
	r0 = asint(gbufferTexture1.Load(r0.xyz));
	r1.yzw = asint(asfloat(r2.xyz) * asfloat(r2.xyz));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r2 = asint(StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)));
		r1.x = asint(asfloat(r1.x) + -(asfloat(r2.y)));
		r1.x = asint(asfloat(r1.x) * asfloat(r2.x));
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r2.xyz = asint(-(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz);
	} else {
		r4 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0);
		r2.xyz = asint(r4.xyz + gViewInverse[3].xyz);
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r2.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + asfloat(r2.xyz));
	r0.w = asint(r3.y * r3.y);
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r3.yzw = asfloat(r2.xyz) + -(i.texcoord2.xyz);
	r4.xyz = -(gDeferredLightDirection.zxy) * gDeferredLightTangent.yzx;
	r4.xyz = -(gDeferredLightDirection.yzx) * gDeferredLightTangent.zxy + -(r4.xyz);
	r4.x = dot(r4.xyz, r3.yzw);
	r4.y = dot(gDeferredLightTangent.xyz, r3.yzw);
	r1.x = asint(dot(-(gDeferredLightDirection.xyz), r3.yzw));
	r2.w = (gDeferredLightType == 2) ? -1 : 0;
	r4.z = abs(gDeferredLightConeOffset) + 60;
	r4.z = 120 / r4.z;
	r4.z = r4.z * gDeferredLightConeAngle;
	r4.z = r4.z * r4.z;
	r4.z = asfloat(r1.x) * r4.z;
	r4.z = -1 / r4.z;
	r4.zw = r4.zz * r4.xy;
	r3.y = dot(r3.yzw, r3.yzw);
	r3.y = sqrt(r3.y);
	r1.x = asint(asfloat(r1.x) / r3.y);
	r1.x = asint(-(asfloat(r1.x)) + 1);
	r1.x = asint(asfloat(r1.x) * r3.y);
	r1.x = asint(1 / asfloat(r1.x));
	r3.yz = asfloat(r1.xx) * r4.xy;
	r3.yz = (r2.ww != 0) ? r4.zw : r3.yz;
	r3.yz = r3.yz * float2(0.5, 0.5) + float2(0.5, 0.5);
	r4 = gDeferredLightSampler_tex.SampleLevel(gDeferredLightSampler, r3.yz, 0);
	r5 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0);
	r3.yzw = r5.xyz + gViewInverse[3].xyz;
	r3.yzw = asfloat(r2.xyz) + -(r3.yzw);
	r3.yzw = r3.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r3.yzw, r3.yzw));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r3.yzw = asfloat(r1.xxx) * r3.yzw;
	r2.xyz = asint(-(asfloat(r2.xyz)) + i.texcoord2.xyz);
	r1.x = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r2.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r2.xyz = asint(asfloat(r2.www) * asfloat(r2.xyz));
	r1.x = asint(saturate(-(asfloat(r1.x)) * i.texcoord1.y + 1));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) * 4.00001001);
	r1.x = asint(exp2(asfloat(r1.x)));
	r1.x = asint(asfloat(r1.x) + -0.100000001);
	r1.x = asint(max(asfloat(r1.x), 0));
	r1.x = asint(asfloat(r1.x) * 1.11111116);
	r5.xyz = asfloat(r1.xxx) * i.texcoord4.xyz;
	r1.x = asint(dot(asfloat(r2.xyz), i.texcoord3.xyz));
	r1.x = asint(saturate(asfloat(r1.x) * i.texcoord1.w + i.texcoord1.z));
	r5.xyz = asfloat(r1.xxx) * r5.xyz;
	r1.x = asint(dot(r3.yzw, asfloat(r0.xyz)));
	r1.x = asint(asfloat(r1.x) + asfloat(r1.x));
	r3.yzw = asfloat(r0.xyz) * -(asfloat(r1.xxx)) + r3.yzw;
	r1.x = asint(saturate(dot(asfloat(r2.xyz), r3.yzw)));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * 196 + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.x = asint(saturate(dot(asfloat(r2.xyz), asfloat(r0.xyz))));
	r0.y = asint(saturate(asfloat(r0.x) * 2 + -0.5));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.w));
	r0.yzw = asint(asfloat(r0.yyy) * r5.xyz);
	r2.xyz = asint(asfloat(r0.xxx) * r5.xyz);
	r1.xyz = asint(asfloat(r1.yzw) * r4.xyz);
	r0.xyz = asint(r3.xxx * asfloat(r0.yzw));
	o.xyz = asfloat(r1.xyz) * asfloat(r2.xyz) + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
