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

cbuffer PedWind : register(b4)
{
	float4 gWindParams : packoffset(c0);
	float4 AirResist : packoffset(c1);
	float WindStr : packoffset(c2);
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
	float4 color1 : COLOR1;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float3 texcoord3 : TEXCOORD3;
	float4 texcoord4 : TEXCOORD4;
	float4 texcoord5 : TEXCOORD5;
	float3 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	int4 r0;
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float3 r5;
	float3 r6;
	float4 r7;
	int4 r8;
	float4 r9;
	float3 r10;
	float3 r11;
	float3 r12;
	r0 = asint(i.blendindices * float4(255.001953, 255.001953, 255.001953, 255.001953));
	r0 = (int4)asfloat(r0);
	r1 = r0 * int4(3, 3, 3, 3);
	r2 = i.blendweight.y * gBoneMtx[r1.y / 3][0];
	r3 = i.blendweight.y * gBoneMtx[r1.y / 3][1];
	r4 = i.blendweight.y * gBoneMtx[r1.y / 3][2];
	r2 = gBoneMtx[r1.x / 3][0] * i.blendweight.x + r2;
	r3 = gBoneMtx[r1.x / 3][1] * i.blendweight.x + r3;
	r4 = gBoneMtx[r1.x / 3][2] * i.blendweight.x + r4;
	r2 = gBoneMtx[r1.z / 3][0] * i.blendweight.z + r2;
	r3 = gBoneMtx[r1.z / 3][1] * i.blendweight.z + r3;
	r4 = gBoneMtx[r1.z / 3][2] * i.blendweight.z + r4;
	r2 = gBoneMtx[r1.w / 3][0] * i.blendweight.w + r2;
	r3 = gBoneMtx[r1.w / 3][1] * i.blendweight.w + r3;
	r1 = asint(gBoneMtx[r1.w / 3][2] * i.blendweight.w + r4);
	r0.x = (254 < r0.x) ? -1 : 0;
	r2 = (r0.x != 0) ? gBoneMtx[0][0] : r2;
	r3 = (r0.x != 0) ? gBoneMtx[0][1] : r3;
	r1 = (r0.x != 0) ? asint(gBoneMtx[0][2]) : r1;
	r4.xyz = i.position.xyz;
	r4.w = 1;
	r5.x = dot(r2, r4);
	r5.y = dot(r3, r4);
	r5.z = dot(asfloat(r1), r4);
	r4.xyz = r5.yyy * gWorld[1].xyz;
	r4.xyz = r5.xxx * gWorld[0].xyz + r4.xyz;
	r4.xyz = r5.zzz * gWorld[2].xyz + r4.xyz;
	r4.xyz = r4.xyz + gWorld[3].xyz;
	r6 = -(r4.xyz) + gViewInverse[3].xyz;
	r1.w = asint(dot(r2.xyz, i.tangent.xyz));
	r2.w = dot(r3.xyz, i.tangent.xyz);
	r3.w = dot(asfloat(r1.xyz), i.tangent.xyz);
	r7.xyz = r2.www * gWorld[1].xyz;
	r7.xyz = asfloat(r1.www) * gWorld[0].xyz + r7.xyz;
	r7.xyz = r3.www * gWorld[2].xyz + r7.xyz;
	if (r0.x != 0) {
		r8 = asint(clothVertexTexture.Load(r0.y));
		r9 = clothVertexTexture.Load(r0.z);
		r0 = asint(clothVertexTexture.Load(r0.w));
		r10.x = dot(gWorld[0].xyz, asfloat(r8.xyz));
		r10.y = dot(gWorld[1].xyz, asfloat(r8.xyz));
		r10.z = dot(gWorld[2].xyz, asfloat(r8.xyz));
		r8.x = asint(dot(gWorld[0].xyz, r9.xyz));
		r8.y = asint(dot(gWorld[1].xyz, r9.xyz));
		r8.z = asint(dot(gWorld[2].xyz, r9.xyz));
		r9.x = dot(gWorld[0].xyz, asfloat(r0.xyz));
		r9.y = dot(gWorld[1].xyz, asfloat(r0.xyz));
		r9.z = dot(gWorld[2].xyz, asfloat(r0.xyz));
		r0.xyz = asint(-(asfloat(r8.zxy)) + r10.zxy);
		r11 = -(asfloat(r8.yzx)) + r9.yzx;
		r12 = asfloat(r0.xyz) * r11.xyz;
		r0.xyz = asint(asfloat(r0.zxy) * r11.yzx + -(r12.xyz));
		r0.w = asint(dot(asfloat(r0.xyz), asfloat(r0.xyz)));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
		r8.xyz = asint(asfloat(r8.xyz) * i.blendweight.yyy);
		r8.xyz = asint(i.blendweight.zzz * r10.xyz + asfloat(r8.xyz));
		r8.xyz = asint(i.blendweight.xxx * r9.xyz + asfloat(r8.xyz));
		r0.w = asint(i.blendweight.w + -0.5);
		r0.w = asint(asfloat(r0.w) * 0.100000001);
		r5 = asfloat(r0.www) * asfloat(r0.xyz) + asfloat(r8.xyz);
		r8.xyz = asint(r5.yyy * gWorld[1].xyz);
		r8.xyz = asint(r5.xxx * gWorld[0].xyz + asfloat(r8.xyz));
		r8.xyz = asint(r5.zzz * gWorld[2].xyz + asfloat(r8.xyz));
		o.texcoord7 = asfloat(r8.xyz) + gWorld[3].xyz;
		r8.xyz = asint(-(asfloat(r0.yyy)) * gWorld[1].xyz);
		r8.xyz = asint(-(asfloat(r0.xxx)) * gWorld[0].xyz + asfloat(r8.xyz));
		r8.xyz = asint(-(asfloat(r0.zzz)) * gWorld[2].xyz + asfloat(r8.xyz));
		r0.w = asint(dot(asfloat(r8.xyz), asfloat(r8.xyz)));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r8.xyz = asint(asfloat(r0.www) * asfloat(r8.xyz));
		r0.w = asint(dot(r7.xyz, r7.xyz));
		r0.w = asint(rsqrt(asfloat(r0.w)));
		r7.xyz = asfloat(r0.www) * r7.xyz;
		r9.xyz = asfloat(r8.yzx) * r7.zxy;
		r9.xyz = r7.yzx * asfloat(r8.zxy) + -(r9.xyz);
		r9.xyz = r9.xyz * i.tangent.www;
		r0.xyz = asint(-(asfloat(r0.xyz)));
	} else {
		r0.w = asint(dot(r2.xyz, i.normal.xyz));
		r1.w = asint(dot(r3.xyz, i.normal.xyz));
		r1.x = asint(dot(asfloat(r1.xyz), i.normal.xyz));
		r1.yzw = asint(asfloat(r1.www) * gWorld[1].xyz);
		r1.yzw = asint(asfloat(r0.www) * gWorld[0].xyz + asfloat(r1.yzw));
		r8.xyz = asint(asfloat(r1.xxx) * gWorld[2].xyz + asfloat(r1.yzw));
		r1.xyz = asint(r7.zxy * asfloat(r8.yzx));
		r1.xyz = asint(r7.yzx * asfloat(r8.zxy) + -(asfloat(r1.xyz)));
		r9.xyz = asfloat(r1.xyz) * i.tangent.www;
		r0.xyz = asint(i.normal.xyz);
		o.texcoord7 = r4.xyz;
	}
	o.texcoord6.x = dot(r7.xyz, r6.xyz);
	o.texcoord6.y = dot(r9.xyz, r6.xyz);
	o.texcoord6.z = dot(asfloat(r8.xyz), r6.xyz);
	r0.w = asint(saturate(dot(AirResist.xyz, asfloat(r8.xyz))));
	r0.w = asint(-(asfloat(r0.w)) + 1);
	r0.w = asint(-(asfloat(r0.w)) * AirResist.w + 1);
	r1.x = (0.800000012 < asfloat(r0.w)) ? -1 : 0;
	r0.w = (r1.x != 0) ? 1065353216 : r0.w;
	r1.xy = asint(AirResist.ww * float2(4, 1.5) + float2(1, 1));
	r2.x = globalScalars3.z + 0.00000999999975;
	r2.y = globalScalars4.z + 0.00000999999975;
	r2.z = 0.00000999999975;
	r1.z = asint(dot(r2.xyz, r2.xyz));
	r1.z = asint(rsqrt(asfloat(r1.z)));
	r2.xyz = asfloat(r1.zzz) * r2.xyz;
	r1.z = asint(dot(r2.xyz, asfloat(r0.xyz)));
	r1.z = asint(max(asfloat(r1.z), 0.25));
	r1.z = asint(min(asfloat(r1.z), 1));
	r2.xyz = asfloat(r1.xxx) * i.color1.xxz;
	r0.xyz = asint(asfloat(r0.xyz) * -(r2.xyz));
	r1.x = asint(asfloat(r1.y) * globalScalars3.y);
	r1.w = asint(saturate(WindStr));
	r2.xy = r5.xy * float2(6, 4);
	r1.y = asint(globalScalars3.y * asfloat(r1.y) + r2.x);
	r2.x = dot(r5.xzy, float3(10, 10, 10));
	r2.x = asfloat(r1.x) * gWindParams.z + r2.x;
	r2.x = sin(r2.x);
	r1.x = asint(asfloat(r1.x) * gWindParams.w + r2.y);
	r1.xy = asint(sin(asfloat(r1.xy)));
	r0.xyz = asint(asfloat(r0.www) * asfloat(r0.xyz));
	r0.xyz = asint(asfloat(r1.zzz) * asfloat(r0.xyz));
	r0.w = asint(abs(asfloat(r1.y)) * asfloat(r1.w));
	r0.w = asint(abs(r2.x) * asfloat(r0.w));
	r0.w = asint(abs(asfloat(r1.x)) * asfloat(r0.w));
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.www) + r5.xyz);
	r1 = asint(asfloat(r0.y) * gWorldViewProj[1]);
	r1 = asint(asfloat(r0.x) * gWorldViewProj[0] + asfloat(r1));
	r0 = asint(asfloat(r0.z) * gWorldViewProj[2] + asfloat(r1));
	r0 = asint(asfloat(r0) + gWorldViewProj[3]);
	o.texcoord2.y = i.color.y * globalScalars2.w;
	r1.x = asint(i.color.x * globalScalars.z + -1);
	r1.x = asint(gAmbientOcclusionEffect.y * asfloat(r1.x) + 1);
	r1.y = asint(1 / gAmbientOcclusionEffect.y);
	r1.x = asint(asfloat(r1.y) * asfloat(r1.x));
	o.texcoord2.x = min(asfloat(r1.x), 1);
	o.sv_position = asfloat(r0);
	o.texcoord.xy = i.texcoord.xy;
	o.texcoord.zw = float2(0, 0);
	r8.w = r0.w;
	o.texcoord1 = asfloat(r8);
	o.texcoord2.zw = i.color.zw;
	r7.w = i.position.z;
	o.texcoord4 = r7;
	r9.w = i.tangent.w;
	o.texcoord5 = r9;
	o.texcoord3 = r6.xyz;

	return o;
}
