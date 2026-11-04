cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
};

cbuffer LocalShadowParam : register(b4)
{
	float4 dShadowParam0123 : packoffset(c0);
	row_major float4x4 dShadowMatrix : packoffset(c1);
};

cbuffer DeferredLight : register(b7)
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

SamplerState gShadowZSamplerCache : register(s14);
Texture2D gbufferTexture0 : register(t8);
Texture2D<float> gbufferTextureDepth : register(t10);
Texture2D gbufferTexture1 : register(t12);
Texture2D gbufferTexture2 : register(t13);
Texture2D ShadowZTextureCache : register(t14);

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
	float4 r1;
	float4 r2;
	int4 r3;
	float3 r4;
	float3 r5;
	float4 r6;
	int4 r7;
	float4 r8;
	r0.xy = (int2)i.sv_position.xy;
	r0.zw = int2(0, 0);
	r1.x = gbufferTextureDepth.Load(r0.xyw).x;
	r1.yzw = gbufferTexture0.Load(r0.xyw).xyz;
	r2.xy = gbufferTexture2.Load(r0.xyw).xy;
	r0.xyz = asint(gbufferTexture1.Load(r0.xyz).xyz);
	r0.w = asint(r1.x * gDeferredProjParams.z + -(gDeferredProjParams.w));
	r0.w = asint(asfloat(r0.w) * i.texcoord.w);
	r0.w = asint(1 / asfloat(r0.w));
	r3.xyz = asint(-(i.texcoord.xyz) * asfloat(r0.www) + gViewInverse[3].xyz);
	r1.x = r2.y * r2.y;
	r1 = r1 * r1;
	r0.xyz = asint(asfloat(r0.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
	r2.y = dot(asfloat(r0.xyz), asfloat(r0.xyz));
	r2.y = rsqrt(r2.y);
	r0.xyz = asint(asfloat(r0.xyz) * r2.yyy);
	r2.yzw = -(i.texcoord.xyz) * asfloat(r0.www) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = asint(dot(r2.yzw, r2.yzw));
	r0.w = asint(rsqrt(asfloat(r0.w)));
	r2.yzw = asfloat(r0.www) * r2.yzw;
	r4 = -(asfloat(r3.xyz)) + i.texcoord2.xyz;
	r0.w = asint(dot(r4.xyz, r4.xyz));
	r4 = r4.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r3.w = asint(dot(r4.xyz, r4.xyz));
	r3.w = asint(rsqrt(asfloat(r3.w)));
	r4 = asfloat(r3.www) * r4.xyz;
	r0.w = asint(saturate(-(asfloat(r0.w)) * i.texcoord1.y + 1));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r0.w = asint(log2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) * 4.00001001);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + -0.100000001);
	r0.w = asint(max(asfloat(r0.w), 0));
	r0.w = asint(asfloat(r0.w) * 1.11111116);
	r5 = asfloat(r0.www) * i.texcoord4.xyz;
	r0.w = asint(dot(r4.xyz, i.texcoord3.xyz));
	r0.w = asint(saturate(asfloat(r0.w) * i.texcoord1.w + i.texcoord1.z));
	r5 = asfloat(r0.www) * r5.xyz;
	r3.xyz = asint(asfloat(r0.xyz) * float3(0.100000001, 0.100000001, 0.100000001) + asfloat(r3.xyz));
	r6.xyz = asfloat(r3.yyy) * dShadowMatrix[1].xyz;
	r3.xyw = asint(asfloat(r3.xxx) * dShadowMatrix[0].xyz + r6.xyz);
	r3.xyz = asint(asfloat(r3.zzz) * dShadowMatrix[2].xyz + asfloat(r3.xyw));
	r3.xyz = asint(asfloat(r3.xyz) + dShadowMatrix[3].xyz);
	r0.w = (0 < asfloat(r3.z)) ? -1 : 0;
	r3.w = asint(-(abs(asfloat(r3.z))));
	r3.w = asint(dot(asfloat(r3.xyw), asfloat(r3.xyw)));
	r3.w = asint(sqrt(asfloat(r3.w)));
	r3.z = asint(abs(asfloat(r3.z)) + asfloat(r3.w));
	r3.z = asint(1 / asfloat(r3.z));
	r3.xy = asint(asfloat(r3.zz) * asfloat(r3.xy));
	r3.z = asint(asfloat(r3.w) * -(dShadowParam0123.w));
	r3.xy = asint(asfloat(r3.xy) * float2(0.5, -0.5) + float2(0.5, 0.5));
	r6 = asfloat(r3.xxyy) / dShadowParam0123.y;
	r6 = frac(r6);
	r7.xy = (float2(0.5, 0.5) < r6.yw) ? -1 : 0;
	r6 = r6 + float4(-0.5, 0.5, -0.5, 0.5);
	r6.xy = (r7.xy != 0) ? r6.xz : r6.yw;
	if (r0.w == 0) {
		r7 = asint(ShadowZTextureCache.Gather(gShadowZSamplerCache, asfloat(r3.xy)));
		r7 = (asfloat(r7) >= asfloat(r3.z)) ? -1 : 0;
		r7 = r7 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	} else {
		r8 = ShadowZTextureCache.GatherGreen(gShadowZSamplerCache, asfloat(r3.xy));
		r3 = (r8 >= asfloat(r3.z)) ? -1 : 0;
		r7 = r3 & int4(1065353216, 1065353216, 1065353216, 1065353216);
	}
	r3.xy = asint(-(asfloat(r7.wz)) + asfloat(r7.xy));
	r3.xy = asint(r6.yy * asfloat(r3.xy) + asfloat(r7.wz));
	r0.w = asint(-(asfloat(r3.x)) + asfloat(r3.y));
	r0.w = asint(r6.x * asfloat(r0.w) + asfloat(r3.x));
	r3.x = asint(-(dShadowParam0123.z) + 1);
	r0.w = asint(asfloat(r0.w) * asfloat(r3.x) + dShadowParam0123.z);
	r3.xyz = asint(asfloat(r0.www) * r5.xyz);
	r0.w = asint(dot(r2.yzw, asfloat(r0.xyz)));
	r0.w = asint(asfloat(r0.w) + asfloat(r0.w));
	r2.yzw = asfloat(r0.xyz) * -(asfloat(r0.www)) + r2.yzw;
	r0.w = asint(saturate(dot(r4.xyz, r2.yzw)));
	r0.w = asint(asfloat(r0.w) + 0.00000999999975);
	r1.x = r1.x * 196 + 0.00000999999975;
	r0.w = asint(log2(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) * r1.x);
	r0.w = asint(exp2(asfloat(r0.w)));
	r0.x = asint(saturate(dot(r4.xyz, asfloat(r0.xyz))));
	r0.y = asint(saturate(asfloat(r0.x) * 2 + -0.5));
	r0.y = asint(asfloat(r0.y) * asfloat(r0.w));
	r0.yzw = asint(asfloat(r0.yyy) * asfloat(r3.xyz));
	r2.yzw = asfloat(r0.xxx) * asfloat(r3.xyz);
	r0.xyz = asint(asfloat(r0.yzw) * r2.xxx);
	o.xyz = r1.yzw * r2.yzw + asfloat(r0.xyz);
	o.w = 1;

	return o;
}
