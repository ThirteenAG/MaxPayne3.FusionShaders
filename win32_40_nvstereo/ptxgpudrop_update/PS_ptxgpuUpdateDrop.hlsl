cbuffer PtxGPUUpdateAttribs : register(b4)
{
	row_major float4x4 gDepthViewProjMtx : packoffset(c0);
	row_major float4x4 gBoxTransform : packoffset(c4);
	float3 gGravity : packoffset(c8);
	float gTimeStep : packoffset(c8.w);
	float gResetParticles : packoffset(c9);
	float3 gBoxCentreOffset : packoffset(c9.y);
	float3 gBoxSize : packoffset(c10);
	float2 gLifeMinMax : packoffset(c11);
	float2 gSplashLifeMinMax : packoffset(c11.z);
	float3 gVelocityMin : packoffset(c12);
	float3 gVelocityMax : packoffset(c13);
};

SamplerState ParticlePosXYTexSampler : register(s0);
SamplerState ParticlePosZWTexSampler : register(s1);
SamplerState ParticleCollisionSampler : register(s4);
SamplerState NoiseTexSampler : register(s5);
SamplerState InitPositionTexSampler : register(s6);
SamplerState InitVelocityTexSampler : register(s7);
Texture2D ParticlePosXYTexSampler_tex : register(t0);
Texture2D ParticlePosZWTexSampler_tex : register(t1);
Texture2D ParticleCollisionSampler_tex : register(t4);
Texture2D NoiseTexSampler_tex : register(t5);
Texture2D InitPositionTexSampler_tex : register(t6);
Texture2D InitVelocityTexSampler_tex : register(t7);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	int4 r1;
	int4 r2;
	int4 r3;
	float4 r4;
	float4 r5;
	float4 r6;
	float4 r7;
	float4 r8;
	float4 r9;
	float3 r10;
	float3 r11;
	r0.x = (gSplashLifeMinMax.y < gSplashLifeMinMax.x) ? -1 : 0;
	if (r0.x != 0) {
		r0 = asint(InitPositionTexSampler_tex.Sample(InitPositionTexSampler, i.texcoord.xy));
		r1 = asint(InitVelocityTexSampler_tex.Sample(InitVelocityTexSampler, i.texcoord.xy).xywz);
		r2.xyz = r1.xyw;
	} else {
		r0 = asint(ParticlePosXYTexSampler_tex.Sample(ParticlePosXYTexSampler, i.texcoord.xy));
		r1 = asint(ParticlePosZWTexSampler_tex.Sample(ParticlePosZWTexSampler, i.texcoord.xy).xywz);
		r2.xyz = r1.xyw;
	}
	r2.w = asint(frac(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + -(asfloat(r2.w)));
	r3.x = (asfloat(r1.z) >= 10000) ? -1 : 0;
	r1.x = asint(asfloat(r1.z) + -10000);
	r1.yw = int2(1065353216, 0);
	r1.xy = (r3.xx != 0) ? r1.yx : r1.wz;
	r1.z = asint(frac(asfloat(r1.y)));
	r1.y = asint(-(asfloat(r1.z)) + asfloat(r1.y));
	r3.xyz = asint(gBoxTransform[2].xyz * float3(-1, -1, 0));
	r1.w = asint(dot(asfloat(r3.xy), asfloat(r3.xy)));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r3.xyz = asint(asfloat(r1.www) * asfloat(r3.xyz));
	r4.xyz = gBoxTransform[0].xyz * float3(1, 1, 0);
	r1.w = asint(dot(r4.xy, r4.xy));
	r1.w = asint(rsqrt(asfloat(r1.w)));
	r4.xyz = asfloat(r1.www) * r4.xyz;
	r5.xyz = gBoxCentreOffset.xxx * r4.xyz + gBoxTransform[3].xyz;
	r5.xyz = gBoxCentreOffset.yyy * asfloat(r3.xyz) + r5.xyz;
	r5.xyz = gBoxCentreOffset.zzz * float3(0, 0, 1) + r5.xyz;
	r6.x = asfloat(r0.w) * 0.00999999978 + -(gTimeStep);
	r0.w = (0 >= r6.x) ? -1 : 0;
	r1.w = (0 < gResetParticles) ? -1 : 0;
	r0.w = r0.w | r1.w;
	r7.xy = asfloat(r0.xy) * float2(0.0625, 0.0625) + i.texcoord.xy;
	r7 = NoiseTexSampler_tex.Sample(NoiseTexSampler, r7.xy);
	if (r0.w != 0) {
		r8 = NoiseTexSampler_tex.Sample(NoiseTexSampler, i.texcoord.xy);
		r9.xyz = r7.wzy + float3(-0.5, -0.5, -0.5);
		r10 = r4.xyz * gBoxSize.xxx;
		r10 = r10.xyz * r9.xxx + r5.xyz;
		r11 = asfloat(r3.xyz) * gBoxSize.yyy;
		r10 = r11.xyz * r9.yyy + r10.xyz;
		r9.xyw = float3(0, 0, 1);
		r11 = r9.zzw * gBoxSize.zzz;
		r0.xyz = asint(r11.xyz * r9.xyz + r10.xyz);
		r9.xyz = -(gVelocityMin.xyz) + gVelocityMax.xyz;
		r2.xyz = asint(r9.xyz * r8.xyz + gVelocityMin.xyz);
		r0.w = asint(-(gLifeMinMax.x) + gLifeMinMax.y);
		r6.xy = asfloat(r0.ww) * r7.ww + gLifeMinMax.xx;
		r1.x = 0;
	} else {
		r6.y = asfloat(r2.w) * 100;
		r7.x = asfloat(r1.z) * 100;
	}
	r0.w = (asfloat(r1.x) == 0) ? -1 : 0;
	r1.xzw = asint(asfloat(r2.xyz) * gTimeStep + asfloat(r0.xyz));
	r5.xyz = -(r5.xyz) + asfloat(r1.xzw);
	r2.w = asint(dot(r4.xy, r5.xy));
	r3.w = asint(dot(asfloat(r3.xy), r5.xy));
	r4.xyz = r4.xyz * gBoxSize.xxx;
	r2.w = asint(asfloat(r2.w) / gBoxSize.x);
	r2.w = asint(asfloat(r2.w) + -0.5);
	r2.w = asint(ceil(asfloat(r2.w)));
	r1.xzw = asint(-(r4.xyz) * asfloat(r2.www) + asfloat(r1.xzw));
	r3.xyz = asint(asfloat(r3.xyz) * gBoxSize.yyy);
	r2.w = asint(asfloat(r3.w) / gBoxSize.y);
	r2.w = asint(asfloat(r2.w) + -0.5);
	r2.w = asint(ceil(asfloat(r2.w)));
	r1.xzw = asint(-(asfloat(r3.xyz)) * asfloat(r2.www) + asfloat(r1.xzw));
	r3.xyz = asint(gBoxSize.zzz * float3(0, 0, 1));
	r2.w = asint(r5.z / gBoxSize.z);
	r2.w = asint(asfloat(r2.w) + -0.5);
	r2.w = asint(ceil(asfloat(r2.w)));
	r3.xyz = asint(-(asfloat(r3.xyz)) * asfloat(r2.www) + asfloat(r1.xzw));
	r1.xzw = asint(asfloat(r3.yyy) * gDepthViewProjMtx[1].xyz);
	r1.xzw = asint(asfloat(r3.xxx) * gDepthViewProjMtx[0].xyz + asfloat(r1.xzw));
	r1.xzw = asint(asfloat(r3.zzz) * gDepthViewProjMtx[2].xyz + asfloat(r1.xzw));
	r4.xyz = asfloat(r1.xzw) + gDepthViewProjMtx[3].xyz;
	r4.w = -(r4.y) + 1;
	r5 = ParticleCollisionSampler_tex.Sample(ParticleCollisionSampler, r4.xw);
	if (r0.w != 0) {
		o.sv_target1.xyz = gGravity.xyz * gTimeStep + asfloat(r2.xyz);
		r0.w = asint(-(r5.x) + 1);
		r1.x = (asfloat(r0.w) < r4.z) ? -1 : 0;
		if (r1.x == 0) {
			r0.w = asint(asfloat(r0.w) + -(gDepthViewProjMtx[3].z));
			r3.w = asint(asfloat(r0.w) / gDepthViewProjMtx[2].z);
			r4 = NoiseTexSampler_tex.Sample(NoiseTexSampler, i.texcoord.xy);
			r0.w = asint(-(gSplashLifeMinMax.x) + gSplashLifeMinMax.y);
			r6.x = asfloat(r0.w) * r4.x + gSplashLifeMinMax.x;
			r6.y = gSplashLifeMinMax.y;
			r6.z = 1;
		} else {
			r6.w = 0;
			r6.xyz = r6.xyw;
			r3.w = r3.z;
		}
		o.sv_target.xyz = asfloat(r3.xyw);
	} else {
		o.sv_target.xyz = asfloat(r0.xyz);
		o.sv_target1.xyz = asfloat(r2.xyz);
		r6.z = 1;
	}
	r0.x = asint(r6.x * 100);
	r0.x = asint(floor(asfloat(r0.x)));
	o.sv_target.w = r6.y * 0.00999999978 + asfloat(r0.x);
	r0.x = asint(floor(asfloat(r1.y)));
	r0.x = asint(r6.z * 10000 + asfloat(r0.x));
	o.sv_target1.w = r7.x * 0.00999999978 + asfloat(r0.x);

	return o;
}
