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

SamplerState gDeferredLightShadowMap0 : register(s4);
SamplerState StereoParmsTex : register(s9);
Texture2D gDeferredLightShadowMap0_tex : register(t4);
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
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
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
	r1.x = asint(sqrt(i.texcoord1.w));
	r3.yzw = asfloat(r2.yzx) + -(i.texcoord1.yzx);
	r4.xyz = r3.yzw * float3(1, -1, 1);
	r2.w = (0 < r3.w) ? -1 : 0;
	r3.yz = (r2.ww != 0) ? float2(0, 1) : float2(1, 0);
	r4.w = -(abs(r4.z));
	r2.w = asint(dot(r4.xyw, r4.xyw));
	r2.w = asint(sqrt(asfloat(r2.w)));
	r3.w = abs(r4.z) + asfloat(r2.w);
	r3.w = 1 / r3.w;
	r4.xy = r3.ww * r4.xy;
	r1.x = asint(asfloat(r1.x) * asfloat(r2.w));
	r1.x = asint(min(asfloat(r1.x), 1));
	r4.xy = r4.xy * float2(0.5, -0.5) + float2(0.5, 0.5);
	r4 = gDeferredLightShadowMap0_tex.Sample(gDeferredLightShadowMap0, r4.xy);
	r2.w = asint(dot(r4.xy, r3.yz));
	r1.x = (asfloat(r2.w) >= asfloat(r1.x)) ? -1 : 0;
	r1.x = r1.x & 1065353216;
	r3.yzw = i.texcoord.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r2.w = asint(dot(r3.yzw, r3.yzw));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r3.yzw = asfloat(r2.www) * r3.yzw;
	r2.w = asint(dot(r3.yzw, asfloat(r0.xyz)));
	r2.w = asint(asfloat(r2.w) + asfloat(r2.w));
	r3.yzw = asfloat(r0.xyz) * -(asfloat(r2.www)) + r3.yzw;
	r2.xyz = asint(-(asfloat(r2.xyz)) + i.texcoord1.xyz);
	r2.w = asint(dot(asfloat(r2.xyz), asfloat(r2.xyz)));
	r4.x = saturate(-(asfloat(r2.w)) * i.texcoord1.w + 1);
	r4.x = r4.x * r4.x;
	r4.x = r4.x * r4.x + -0.100000001;
	r4.x = max(r4.x, 0);
	r4.x = r4.x * 1.11111116;
	r2.w = asint(asfloat(r2.w) + 0.00000999999975);
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r2.xyz = asint(asfloat(r2.www) * asfloat(r2.xyz));
	r0.x = asint(saturate(dot(asfloat(r2.xyz), asfloat(r0.xyz))));
	r0.y = asint(saturate(dot(asfloat(r2.xyz), r3.yzw)));
	r0.z = asint(dot(asfloat(r2.xyz), i.texcoord3.xyz));
	r0.z = asint(saturate(-(asfloat(r0.z)) * i.texcoord2.w + i.texcoord3.w));
	r2.xyz = asint(asfloat(r0.xxx) * i.texcoord2.xyz);
	r2.xyz = asint(asfloat(r0.zzz) * asfloat(r2.xyz));
	r2.xyz = asint(r4.xxx * asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r1.xxx) * asfloat(r2.xyz));
	r0.x = asint(asfloat(r0.y) + 0.00000999999975);
	r0.y = asint(asfloat(r0.w) * 49 + 0.00000999999975);
	r0.x = asint(log2(asfloat(r0.x)));
	r0.x = asint(asfloat(r0.x) * asfloat(r0.y));
	r0.x = asint(exp2(asfloat(r0.x)));
	r0.xyz = asint(asfloat(r0.xxx) * asfloat(r2.xyz));
	r0.xyz = asint(asfloat(r0.xyz) * r3.xxx);
	o.xyz = asfloat(r1.yzw) * asfloat(r2.xyz) + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
