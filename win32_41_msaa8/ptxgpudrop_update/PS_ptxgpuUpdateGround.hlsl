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
	float4 r1;
	int4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	float3 r6;
	float4 r7;
	int4 r8;
	float3 r9;
	float3 r10;
	float3 r11;
	float3 r12;
	r0.x = (gSplashLifeMinMax.y < gSplashLifeMinMax.x) ? -1 : 0;
	if (r0.x != 0) {
		r0 = asint(InitPositionTexSampler_tex.Sample(InitPositionTexSampler, i.texcoord.xy));
		r1 = InitVelocityTexSampler_tex.Sample(InitVelocityTexSampler, i.texcoord.xy);
	} else {
		r0 = asint(ParticlePosXYTexSampler_tex.Sample(ParticlePosXYTexSampler, i.texcoord.xy));
		r1 = ParticlePosZWTexSampler_tex.Sample(ParticlePosZWTexSampler, i.texcoord.xy);
	}
	r2.x = asint(frac(asfloat(r0.w)));
	r0.w = asint(asfloat(r0.w) + -(asfloat(r2.x)));
	r2.y = (r1.w >= 10000) ? -1 : 0;
	r2.z = asint(r1.w + -10000);
	r1.w = (r2.y != 0) ? asfloat(r2.z) : r1.w;
	r2.z = asint(frac(r1.w));
	r1.w = r1.w + -(asfloat(r2.z));
	r3.xyz = gBoxTransform[2].xyz * float3(-1, -1, 0);
	r2.w = asint(dot(r3.xy, r3.xy));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r3.xyz = asfloat(r2.www) * r3.xyz;
	r4.xyz = gBoxTransform[0].xyz * float3(1, 1, 0);
	r2.w = asint(dot(r4.xy, r4.xy));
	r2.w = asint(rsqrt(asfloat(r2.w)));
	r4.xyz = asfloat(r2.www) * r4.xyz;
	r5.xyz = gBoxCentreOffset.xxx * r4.xyz + gBoxTransform[3].xyz;
	r5.xyz = gBoxCentreOffset.yyy * r3.xyz + r5.xyz;
	r5.xyz = gBoxCentreOffset.zzz * float3(0, 0, 1) + r5.xyz;
	r6.y = asfloat(r0.w) * 0.00999999978 + -(gTimeStep);
	r0.w = (0 >= r6.y) ? -1 : 0;
	r7.xy = asfloat(r0.xy) * float2(0.0625, 0.0625) + i.texcoord.xy;
	r7 = NoiseTexSampler_tex.Sample(NoiseTexSampler, r7.xy);
	r8.xyz = asint(r7.wzy + float3(-0.5, -0.5, -0.5));
	r9 = r4.xyz * gBoxSize.xxx;
	r10 = r9.xyz * asfloat(r8.xxx) + r5.xyz;
	r11 = r3.xyz * gBoxSize.yyy;
	r10 = r11.xyz * asfloat(r8.yyy) + r10.xyz;
	r8.w = 1065353216;
	r12 = asfloat(r8.zzw) * gBoxSize.zzz;
	r8.xy = int2(0, 0);
	r8.xyz = asint(r12.xyz * asfloat(r8.xyz) + r10.xyz);
	r3.zw = asfloat(r8.yy) * gDepthViewProjMtx[1].xy;
	r3.zw = asfloat(r8.xx) * gDepthViewProjMtx[0].xy + r3.zw;
	r3.zw = asfloat(r8.zz) * gDepthViewProjMtx[2].xy + r3.zw;
	r10.xy = r3.zw + gDepthViewProjMtx[3].xy;
	r10.z = -(r10.y) + 1;
	r2.w = asint(ParticleCollisionSampler_tex.Sample(ParticleCollisionSampler, r10.xz).x);
	if (r0.w != 0) {
		r10 = NoiseTexSampler_tex.Sample(NoiseTexSampler, i.texcoord.xy).xyz;
		r0.w = asint(-(asfloat(r2.w)) + 1);
		r0.w = asint(asfloat(r0.w) + -(gDepthViewProjMtx[3].z));
		r8.w = asint(asfloat(r0.w) / gDepthViewProjMtx[2].z);
		r12 = -(gVelocityMin.xyz) + gVelocityMax.xyz;
		r1.xyz = r12.xyz * r10.xyz + gVelocityMin.xyz;
		r0.w = asint(-(gLifeMinMax.x) + gLifeMinMax.y);
		r6.y = asfloat(r0.w) * r7.w + gLifeMinMax.x;
		r0.xyz = r8.xyw;
		r6.x = r7.x;
		r3.zw = r6.yx;
	} else {
		r3.zw = asfloat(r2.xz) * float2(100, 100);
	}
	r0.xyz = asint(r1.xyz * gTimeStep + asfloat(r0.xyz));
	r2.xz = asint(-(r5.xy) + asfloat(r0.xy));
	r0.w = asint(dot(r4.xy, asfloat(r2.xz)));
	r2.x = asint(dot(r3.xy, asfloat(r2.xz)));
	r0.w = asint(asfloat(r0.w) / gBoxSize.x);
	r0.w = asint(asfloat(r0.w) + -0.5);
	r0.w = asint(ceil(asfloat(r0.w)));
	r4.xyz = -(r9.xyz) * asfloat(r0.www) + asfloat(r0.xyz);
	r0.w = asint(asfloat(r2.x) / gBoxSize.y);
	r0.w = asint(asfloat(r0.w) + -0.5);
	r0.w = asint(ceil(asfloat(r0.w)));
	r4.xyz = -(r11.xyz) * asfloat(r0.www) + r4.xyz;
	r0.xyz = asint(-(asfloat(r0.xyz)) + r4.xyz);
	r0.xyz = (asfloat(r0.xyz) != float3(0, 0, 0)) ? -1 : 0;
	r0.x = r0.y | r0.x;
	r0.x = r0.z | r0.x;
	r0.yzw = asint(r4.yyy * gDepthViewProjMtx[1].xyz);
	r0.yzw = asint(r4.xxx * gDepthViewProjMtx[0].xyz + asfloat(r0.yzw));
	r0.yzw = asint(r4.zzz * gDepthViewProjMtx[2].xyz + asfloat(r0.yzw));
	r5.xyz = asfloat(r0.yzw) + gDepthViewProjMtx[3].xyz;
	r5.w = -(r5.y) + 1;
	r0.y = asint(ParticleCollisionSampler_tex.Sample(ParticleCollisionSampler, r5.xw).x);
	r0.y = asint(-(asfloat(r0.y)) + 1);
	r0.z = (asfloat(r0.y) < r5.z) ? -1 : 0;
	r0.z = (r0.z == 0) ? -1 : 0;
	r0.x = r0.x | r0.z;
	r0.y = asint(asfloat(r0.y) + -(gDepthViewProjMtx[3].z));
	r6.x = asfloat(r0.y) / gDepthViewProjMtx[2].z;
	r0.y = asint(-(r4.z) + r6.x);
	r0.y = (1 < asfloat(r0.y)) ? -1 : 0;
	r4.w = 0;
	r0.yz = asint((r0.yy != 0) ? r4.zw : r6.xy);
	r6.z = r4.z;
	r0.xy = (r0.xx != 0) ? r0.yz : asint(r6.zy);
	o.sv_target1.xyz = gGravity.xyz * gTimeStep + r1.xyz;
	r0.y = asint(asfloat(r0.y) * 100);
	r0.y = asint(floor(asfloat(r0.y)));
	o.sv_target.w = r3.z * 0.00999999978 + asfloat(r0.y);
	r0.y = r2.y & 1176256512;
	r0.z = asint(floor(r1.w));
	r0.y = asint(asfloat(r0.z) + asfloat(r0.y));
	o.sv_target1.w = r3.w * 0.00999999978 + asfloat(r0.y);
	o.sv_target.xy = r4.xy;
	o.sv_target.z = asfloat(r0.x);

	return o;
}
