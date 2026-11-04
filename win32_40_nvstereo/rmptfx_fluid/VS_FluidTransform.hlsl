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
	float4 globalFogOffsetE : packoffset(c6);
	float4 globalFogOffsetN : packoffset(c7);
	float4 globalFogColorN : packoffset(c8);
	float4 globalScreenSize : packoffset(c9);
	float4 globalDayNightEffects : packoffset(c10);
	float4 ColorCorrectTopAndPedReflectScale : packoffset(c11);
	float4 ColorCorrectBottomOffset : packoffset(c12);
	float4 ColorShift : packoffset(c13);
	float4 deSatContrastGamma : packoffset(c14);
	float4 colorize : packoffset(c15);
	float4 globalUmScalars : packoffset(c16);
	float4 gToneMapScalers : packoffset(c17);
	float4 gAmbientOcclusionEffect : packoffset(c18);
};

cbuffer Fluid : register(b1)
{
	float4 DensityFieldCenter : packoffset(c0);
	float4 DensityField[32] : packoffset(c1);
	float4 MovementVector : packoffset(c33);
	row_major float4x4 ViewProjMtx : packoffset(c34);
	float Occlusion : packoffset(c38);
	float Glob : packoffset(c38.y);
	float Streak : packoffset(c38.z);
};

static const float4 icb[4] =
{
	float4(1, 0, 0, 0),
	float4(0, 1, 0, 0),
	float4(0, 0, 1, 0),
	float4(0, 0, 0, 1),
};

struct VS_IN
{
	float3 position : POSITION;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float3 normal : NORMAL;
	float4 tangent : TANGENT;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float texcoord8 : TEXCOORD8;
	float4 texcoord1 : TEXCOORD1;
	float3 texcoord3 : TEXCOORD3;
	float3 texcoord4 : TEXCOORD4;
	float3 texcoord5 : TEXCOORD5;
	float4 texcoord6 : TEXCOORD6;
	float4 texcoord7 : TEXCOORD7;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	int4 r1;
	int4 r2;
	float4 r3;
	int4 r4;
	int4 r5;
	int4 r6;
	int3 r7;
	float3 r8;
	r0.xyz = i.position.yyy * gWorld[1].xyz;
	r0.xyz = i.position.xxx * gWorld[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * gWorld[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + gWorld[3].xyz;
	o.texcoord3 = -(r0.xyz) + gViewInverse[3].xyz;
	r1.xyz = asint(i.normal.yyy * gWorld[1].xyz);
	r1.xyz = asint(i.normal.xxx * gWorld[0].xyz + asfloat(r1.xyz));
	r1.xyz = asint(i.normal.zzz * gWorld[2].xyz + asfloat(r1.xyz));
	r1.xyz = asint(asfloat(r1.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = dot(asfloat(r1.xyz), asfloat(r1.xyz));
	r0.w = rsqrt(r0.w);
	r1.xyz = asint(r0.www * asfloat(r1.xyz));
	r2.xyz = asint(i.tangent.yyy * gWorld[1].xyz);
	r2.xyz = asint(i.tangent.xxx * gWorld[0].xyz + asfloat(r2.xyz));
	r2.xyz = asint(i.tangent.zzz * gWorld[2].xyz + asfloat(r2.xyz));
	r2.xyz = asint(asfloat(r2.xyz) + float3(0.00000999999975, 0.00000999999975, 0.00000999999975));
	r0.w = dot(asfloat(r2.xyz), asfloat(r2.xyz));
	r0.w = rsqrt(r0.w);
	r2.xyz = asint(r0.www * asfloat(r2.xyz));
	r3.xyz = asfloat(r1.yzx) * asfloat(r2.zxy);
	r3.xyz = asfloat(r2.yzx) * asfloat(r1.zxy) + -(r3.xyz);
	o.texcoord5 = r3.xyz * i.tangent.www;
	r0.w = dot(asfloat(r1.xyz), MovementVector.xyz);
	r1.w = (0 >= r0.w) ? -1 : 0;
	r1.w = (r1.w != 0) ? 1077936128 : 1065353216;
	r0.w = r0.w * asfloat(r1.w);
	r0.w = r0.w * MovementVector.w;
	r0.w = r0.w * Streak;
	r0.xyz = MovementVector.xyz * r0.www + r0.xyz;
	r3.xy = float2(Glob, Occlusion) * DensityField[15].zz;
	r1.w = asint(r3.x * 0.0199999996);
	r1.w = asint(saturate(asfloat(r1.w)));
	r3.xzw = asfloat(r1.www) * asfloat(r1.xyz);
	r3.xzw = r3.xzw / DensityFieldCenter.www;
	r1.w = asint(dot(r0.xyz, float3(10, 10, 10)));
	r1.w = asint(asfloat(r1.w) * 1500);
	r1.w = asint(sin(asfloat(r1.w)));
	r1.w = asint(asfloat(r1.w) + 0.25);
	r0.xyz = r3.xzw * asfloat(r1.www) + r0.xyz;
	r3.xzw = float3(0, 0, 0);
	r1.w = 0;
	r2.w = 0;
	while (true) {
		r4.x = (r2.w >= 5) ? -1 : 0;
		if (r4.x != 0) break;
		r4.x = asint((float)r2.w);
		r5.xyz = asint(r3.xzw);
		r4.w = r1.w;
		r5.w = 0;
		while (true) {
			r6.x = (r5.w >= 5) ? -1 : 0;
			if (r6.x != 0) break;
			r6.x = r5.w * 5;
			r6.x = r2.w * 25 + r6.x;
			r4.y = asint((float)r5.w);
			r6.yzw = r5.xyz;
			r7.x = r4.w;
			r7.y = 0;
			while (true) {
				r7.z = (r7.y >= 5) ? -1 : 0;
				if (r7.z != 0) break;
				r7.z = r6.x + r7.y;
				r4.z = asint((float)r7.y);
				r8 = asfloat(r4.xyz) + float3(-2, -2, -2);
				r4.z = r7.z & 3;
				r7.z = (uint)r7.z >> 2;
				r4.z = asint(dot(DensityField[r7.z], icb[r4.z]));
				r6.yzw = asint(r8.xyz * asfloat(r4.zzz) + asfloat(r6.yzw));
				r7.z = asint(dot(abs(r8.xyz), float3(1, 1, 1)));
				r7.z = asint(asfloat(r7.z) + 1);
				r4.z = asint(asfloat(r4.z) / asfloat(r7.z));
				r7.x = asint(asfloat(r4.z) + asfloat(r7.x));
				r7.y = r7.y + 1;
			}
			r5.xyz = r6.yzw;
			r4.w = r7.x;
			r5.w = r5.w + 1;
		}
		r3.xzw = asfloat(r5.xyz);
		r1.w = r4.w;
		r2.w = r2.w + 1;
	}
	r4.w = asint(min(asfloat(r1.w), 100));
	r3.xzw = r3.xzw + float3(0.00000999999975, 0.00000999999975, 0.00000999999975);
	r1.w = asint(dot(r3.xzw, r3.xzw));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r4.xyz = asint(asfloat(r1.www) * r3.xzw);
	r1.w = asint(dot(asfloat(r1.xyz), asfloat(r4.xyz)));
	r1.w = asint(saturate(asfloat(r1.w) + 0.5));
	r3.xzw = asfloat(r1.www) * asfloat(r1.xyz);
	r3.xzw = asfloat(r4.www) * r3.xzw;
	r3.xzw = r3.xzw * Glob;
	r3.xzw = r3.xzw * float3(0.00999999978, 0.00999999978, 0.00999999978);
	r3.xzw = r3.xzw / DensityFieldCenter.www;
	r0.xyz = r0.xyz + r3.xzw;
	r5 = asint(r0.y * ViewProjMtx[1]);
	r5 = asint(r0.x * ViewProjMtx[0] + asfloat(r5));
	r5 = asint(r0.z * ViewProjMtx[2] + asfloat(r5));
	r5 = asint(asfloat(r5) + ViewProjMtx[3]);
	r1.w = asint(dot(i.color.xy, globalDayNightEffects.zw));
	r1.w = asint(asfloat(r1.w) * globalScalars.z + -1);
	r1.w = asint(gAmbientOcclusionEffect.x * asfloat(r1.w) + 1);
	r6.xy = asint(asfloat(r1.ww) * gAmbientOcclusionEffect.yy);
	r1.w = asint(-(r3.y) * 0.0149999997 + 1);
	r1.w = asint(max(asfloat(r1.w), 0.5));
	r6.z = asint(i.color.z);
	o.color.xyz = asfloat(r1.www) * asfloat(r6.xyz);
	o.sv_position = asfloat(r5);
	o.color.w = i.color.w;
	o.texcoord1.w = asfloat(r5.w);
	o.texcoord1.xyz = asfloat(r1.xyz);
	o.texcoord6.xyz = r0.xyz;
	o.texcoord6.w = 1;
	o.texcoord7 = asfloat(r4);
	o.texcoord = i.texcoord.xy;
	o.texcoord8 = r0.w;
	o.texcoord4 = asfloat(r2.xyz);

	return o;
}
