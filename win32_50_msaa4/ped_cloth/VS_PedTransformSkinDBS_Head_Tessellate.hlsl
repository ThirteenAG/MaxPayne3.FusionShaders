cbuffer rage_bonemtx : register(b1)
{
	row_major float3x4 gBoneMtx[40] : packoffset(c0);
};

cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
	row_major float4x4 gViewInverse : packoffset(c12);
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
	float4 globalScreenSize : packoffset(c8);
	float4 globalDayNightEffects : packoffset(c9);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c10);
	float4 ColorCorrectBottomOffset : packoffset(c11);
	float4 ColorShift : packoffset(c12);
	float4 deSatContrastGamma : packoffset(c13);
	float4 deSatContrastGammaIFX : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

cbuffer CachePedParam : register(b4)
{
	float ArmourStrength : packoffset(c0);
	float bumpiness : packoffset(c0.y);
	float displacementScale : packoffset(c0.z);
	float specularFactor : packoffset(c0.w);
	float3 specMapIntMask : packoffset(c1);
	float4 specMapExpMask : packoffset(c2);
	float4 matMaterialColorScale : packoffset(c3);
	float4 gBloodData : packoffset(c4);
};

cbuffer BloodHitData : register(b7)
{
	float4 gBloodHeadHits[4] : packoffset(c0);
	float4 gBloodHeadCentreMass : packoffset(c4);
};

Buffer<float4> clothVertexTexture : register(t2);

struct VS_IN
{
	float3 position : POSITION;
	float4 blendweight : BLENDWEIGHT;
	float4 blendindices : BLENDINDICES;
	float4 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
	float4 color : COLOR;
};

struct VS_OUT
{
	float4 texcoord8 : TEXCOORD8;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
	float3 texcoord9 : TEXCOORD9;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	float3 r7;
	float4 r8;
	float3 r9;
	float3 r10;
	float3 r11;
	float3 r12;
	r0.xyz = -(i.position.xyz) + gBloodHeadCentreMass.xyz;
	r0.xyz = r0.xyz + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r0.w = dot(r0.xyz, r0.xyz);
	r0.w = rsqrt(r0.w);
	r0.xyz = r0.www * r0.xyz;
	r1.xyz = asint(-(i.position.xyz) + gBloodHeadHits[0].xyz);
	r0.w = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r0.w = sqrt(r0.w);
	r0.w = -(r0.w) + 0.0500000007;
	r0.w = r0.w * 0.239999995;
	r0.w = max(r0.w, 0);
	r1.xyz = asint(-(i.position.xyz) + gBloodHeadHits[1].xyz);
	r1.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(-(asfloat(r1.x)) + 0.0500000007);
	r1.x = asint(asfloat(r1.x) * 0.239999995);
	r0.w = max(r0.w, asfloat(r1.x));
	r1.xyz = asint(-(i.position.xyz) + gBloodHeadHits[2].xyz);
	r1.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(-(asfloat(r1.x)) + 0.0500000007);
	r1.x = asint(asfloat(r1.x) * 0.239999995);
	r0.w = max(r0.w, asfloat(r1.x));
	r1.xyz = asint(-(i.position.xyz) + gBloodHeadHits[3].xyz);
	r1.x = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
	r1.x = asint(sqrt(asfloat(r1.x)));
	r1.x = asint(-(asfloat(r1.x)) + 0.0500000007);
	r1.x = asint(asfloat(r1.x) * 0.239999995);
	r0.w = max(r0.w, asfloat(r1.x));
	r0.xyz = r0.www * r0.xyz;
	r0.xyw = r0.xyz * gBloodData.xxx + i.position.xyz;
	r1 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r1 = (int4)asfloat(r1);
	r2 = r1 * int4(3, 3, 3, 3);
	r3 = i.blendweight.y * gBoneMtx[r2.y / 3][0];
	r4 = i.blendweight.y * gBoneMtx[r2.y / 3][1];
	r5 = i.blendweight.y * gBoneMtx[r2.y / 3][2];
	r3 = gBoneMtx[r2.x / 3][0] * i.blendweight.x + r3;
	r4 = gBoneMtx[r2.x / 3][1] * i.blendweight.x + r4;
	r5 = gBoneMtx[r2.x / 3][2] * i.blendweight.x + r5;
	r3 = gBoneMtx[r2.z / 3][0] * i.blendweight.z + r3;
	r4 = gBoneMtx[r2.z / 3][1] * i.blendweight.z + r4;
	r5 = gBoneMtx[r2.z / 3][2] * i.blendweight.z + r5;
	r3 = gBoneMtx[r2.w / 3][0] * i.blendweight.w + r3;
	r4 = gBoneMtx[r2.w / 3][1] * i.blendweight.w + r4;
	r2 = asint(gBoneMtx[r2.w / 3][2] * i.blendweight.w + r5);
	r1.x = (254 < r1.x) ? -1 : 0;
	r3 = (r1.x != 0) ? gBoneMtx[0][0] : r3;
	r4 = (r1.x != 0) ? gBoneMtx[0][1] : r4;
	r2 = (r1.x != 0) ? asint(gBoneMtx[0][2]) : r2;
	r0.z = 1;
	r5.x = dot(r3.xywz, r0);
	r5.y = dot(r4.xywz, r0);
	r5.z = dot(asfloat(r2.xywz), r0);
	r6 = r5.yyy * gWorld[1].xyz;
	r6 = r5.xxx * gWorld[0].xyz + r6.xyz;
	r6 = r5.zzz * gWorld[2].xyz + r6.xyz;
	r6 = r6.xyz + gWorld[3].xyz;
	r7 = -(r6.xyz) + gViewInverse[3].xyz;
	r2.w = asint(dot(r3.xyz, i.tangent.xyz));
	r3.w = dot(r4.xyz, i.tangent.xyz);
	r4.w = dot(asfloat(r2.xyz), i.tangent.xyz);
	r8.xyz = r3.www * gWorld[1].xyz;
	r8.xyz = asfloat(r2.www) * gWorld[0].xyz + r8.xyz;
	r0.xyz = r4.www * gWorld[2].xyz + r8.xyz;
	if (r1.x != 0) {
		r8.xyz = clothVertexTexture.Load(r1.y).xyz;
		r1.xyz = asint(clothVertexTexture.Load(r1.z).xyz);
		r9 = clothVertexTexture.Load(r1.w).xyz;
		r10.x = dot(gWorld[0].xyz, r8.xyz);
		r10.y = dot(gWorld[1].xyz, r8.xyz);
		r10.z = dot(gWorld[2].xyz, r8.xyz);
		r8.x = dot(gWorld[0].xyz, asfloat(r1.xyz));
		r8.y = dot(gWorld[1].xyz, asfloat(r1.xyz));
		r8.z = dot(gWorld[2].xyz, asfloat(r1.xyz));
		r1.x = asint(dot(gWorld[0].xyz, r9.xyz));
		r1.y = asint(dot(gWorld[1].xyz, r9.xyz));
		r1.z = asint(dot(gWorld[2].xyz, r9.xyz));
		r9 = -(r8.zxy) + r10.zxy;
		r11 = -(r8.yzx) + asfloat(r1.yzx);
		r12 = r9.xyz * r11.xyz;
		r9 = r9.zxy * r11.yzx + -(r12.xyz);
		r1.w = asint(dot(r9.xyz, r9.xyz));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r9 = asfloat(r1.www) * r9.xyz;
		r8.xyz = r8.xyz * i.blendweight.yyy;
		r8.xyz = i.blendweight.zzz * r10.xyz + r8.xyz;
		r1.xyz = asint(i.blendweight.xxx * asfloat(r1.xyz) + r8.xyz);
		r1.w = asint(i.blendweight.w + -0.5);
		r1.w = asint(asfloat(r1.w) * 0.100000001);
		r5.xyz = asfloat(r1.www) * r9.xyz + asfloat(r1.xyz);
		r1.xyz = asint(r5.yyy * gWorld[1].xyz);
		r1.xyz = asint(r5.xxx * gWorld[0].xyz + asfloat(r1.xyz));
		r1.xyz = asint(r5.zzz * gWorld[2].xyz + asfloat(r1.xyz));
		o.texcoord7 = asfloat(r1.xyz) + gWorld[3].xyz;
		r1.xyz = asint(-(r9.yyy) * gWorld[1].xyz);
		r1.xyz = asint(-(r9.xxx) * gWorld[0].xyz + asfloat(r1.xyz));
		r1.xyz = asint(-(r9.zzz) * gWorld[2].xyz + asfloat(r1.xyz));
		r1.w = asint(dot(asfloat(r1.xyz), asfloat(r1.xyz)));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r1.xyz = asint(asfloat(r1.www) * asfloat(r1.xyz));
		r1.w = asint(dot(r0.xyz, r0.xyz));
		r1.w = asint(rsqrt(asfloat(r1.w)));
		r0.xyz = r0.xyz * asfloat(r1.www);
		r8.xyz = asfloat(r1.yzx) * r0.zxy;
		r8.xyz = r0.yzx * asfloat(r1.zxy) + -(r8.xyz);
		r8.xyz = r8.xyz * i.tangent.www;
		r9 = -(r9.xyz);
	} else {
		r1.w = asint(dot(r3.xyz, i.normal.xyz));
		r2.w = asint(dot(r4.xyz, i.normal.xyz));
		r3.w = dot(asfloat(r2.xyz), i.normal.xyz);
		r10 = asfloat(r2.www) * gWorld[1].xyz;
		r10 = asfloat(r1.www) * gWorld[0].xyz + r10.xyz;
		r1.xyz = asint(r3.www * gWorld[2].xyz + r10.xyz);
		r10 = r0.zxy * asfloat(r1.yzx);
		r10 = r0.yzx * asfloat(r1.zxy) + -(r10.xyz);
		r8.xyz = r10.xyz * i.tangent.www;
		r9 = i.normal.xyz;
		o.texcoord7 = r6.xyz;
	}
	o.texcoord6.x = dot(r0.xyz, r7.xyz);
	o.texcoord6.y = dot(r8.xyz, r7.xyz);
	o.texcoord6.z = dot(asfloat(r1.xyz), r7.xyz);
	o.texcoord9.x = dot(r3.xyz, r9.xyz);
	o.texcoord9.y = dot(r4.xyz, r9.xyz);
	o.texcoord9.z = dot(asfloat(r2.xyz), r9.xyz);
	o.texcoord2.y = i.color.y * globalScalars2.w;
	r1.w = asint(i.color.x * globalScalars.z + -1);
	r1.w = asint(gAmbientOcclusionEffect.y * asfloat(r1.w) + 1);
	r2.x = asint(1 / gAmbientOcclusionEffect.y);
	r1.w = asint(asfloat(r1.w) * asfloat(r2.x));
	o.texcoord2.x = min(asfloat(r1.w), 1);
	o.texcoord8.xyz = r5.xyz;
	o.texcoord8.w = 1;
	o.texcoord = i.texcoord;
	o.texcoord1.xyz = asfloat(r1.xyz);
	o.texcoord1.w = 1;
	o.texcoord2.zw = i.color.zw;
	o.texcoord4 = r0;
	r8.w = i.tangent.w;
	o.texcoord5 = r8;

	return o;
}
