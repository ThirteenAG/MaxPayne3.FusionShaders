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

SamplerState StereoParmsTex : register(s9);
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
	float4 r2;
	float3 r3;
	float3 r4;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = asint(gbufferTextureDepth.Load(r0.xyw).x);
	r1.yzw = asint(gbufferTexture0.Load(r0.xyw).xyz);
	r2.xy = gbufferTexture2.Load(r0.xyw).xy;
	r0.xyz = asint(gbufferTexture1.Load(r0.xyz).xyz);
	r1.yzw = asint(asfloat(r1.yzw) * asfloat(r1.yzw));
	r0.w = asint(asfloat(r1.x) * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r1.x = (i.texcoord.w == 1) ? -1 : 0;
	if (r1.x != 0) {
		r1.x = asint(1 / asfloat(r0.w));
		r2.zw = StereoParmsTex_tex.Sample(StereoParmsTex, float2(0.0625, 0.25)).xy;
		r1.x = asint(asfloat(r1.x) + -(r2.w));
		r1.x = asint(asfloat(r1.x) * r2.z);
		r1.x = asint(asfloat(r1.x) * gDeferredProjParams.x);
		r3 = -(gViewInverse[0].xyz) * asfloat(r1.xxx) + gViewInverse[3].xyz;
	} else {
		r4 = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
		r3 = r4.xyz + gViewInverse[3].xyz;
	}
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r3 = -(i.texcoord.xyz) * asfloat(r0.www) + r3.xyz;
	r0.w = asint(r2.y * r2.y);
	r0.w = asint(asfloat(r0.w) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r1.x = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r1.xxx));
	r2.yzw = StereoParmsTex_tex.SampleLevel(StereoParmsTex, float2(0.0625, 0.75), 0).xyz;
	r2.yzw = r2.yzw + gViewInverse[3].xyz;
	r2.yzw = -(r2.yzw) + r3.xyz;
	r2.yzw = r2.yzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r2.yzw, r2.yzw));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r2.yzw = asfloat(r1.xxx) * r2.yzw;
	r3 = -(r3.xyz) + i.texcoord2.xyz;
	r4 = r3.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.x = asint(dot(r4.xyz, r4.xyz));
	r1.x = asint(rsqrt(asfloat(r1.x)));
	r4 = asfloat(r1.xxx) * r4.xyz;
	r1.x = asint(dot(r3.xyz, r3.xyz));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(saturate(-(asfloat(r1.x)) * gDeferredLightRadiusProjShearParams.y + 1));
	r3 = asfloat(r1.xxx) * i.texcoord4.xyz;
	r1.x = asint(dot(r4.xyz, i.texcoord3.xyz));
	r1.x = asint(saturate(asfloat(r1.x) * i.texcoord1.w + i.texcoord1.z));
	r3 = asfloat(r1.xxx) * r3.xyz;
	r1.x = asint(dot(r2.yzw, asfloat(r0.xyz)));
	r1.x = asint(asfloat(r1.x) + asfloat(r1.x));
	r2.yzw = asfloat(r0.xyz) * -(asfloat(r1.xxx)) + r2.yzw;
	r1.x = asint(saturate(dot(r4.xyz, r2.yzw)));
	r1.x = asint(asfloat(r1.x) + 0.00000999999975);
	r0.w = asint(asfloat(r0.w) * 196 + 0.00000999999975);
	r1.x = asint(log2(asfloat(r1.x)));
	r0.w = asint(asfloat(r0.w) * asfloat(r1.x));
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.x = asint(dot(r4.xyz, asfloat(r0.xyz)));
	r0.y = asint(asfloat(r0.x) + 0.5);
	r0.y = asint(saturate(asfloat(r0.y) * 0.25));
	r0.x = asint(saturate(asfloat(r0.x)));
	r0.y = asint(asfloat(r0.x) + asfloat(r0.y));
	r2.yzw = asfloat(r0.yyy) * r3.xyz;
	r0.x = asint(saturate(asfloat(r0.x) * 2 + -0.5));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xxx) * r3.xyz);
	r0.xyz = asint(asfloat(r0.xyz) * r2.xxx);
	o.xyz = asfloat(r1.yzw) * r2.yzw + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
