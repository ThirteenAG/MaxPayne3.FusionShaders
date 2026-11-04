cbuffer _Globals : register(b4)
{
	row_major float4x4 EmitterTransform : packoffset(c211);
	float4 Acceleration_Delta : packoffset(c215);
	float3 EmitterParamPos : packoffset(c216);
	float3 EmitterParamPosRange : packoffset(c217);
	float4 EmitterParamLifeAndSpeed : packoffset(c218);
	float EmitterParamProbablityPhase2 : packoffset(c219);
	float3 EmitterVelocityBoxPos : packoffset(c220);
	float4 EmitterVelocityBoxRange : packoffset(c221);
	float4 gHitPlane : packoffset(c222);
	float3 gCollisionVelocityModifier : packoffset(c223);
	float2 gCollisionLifeModifier : packoffset(c224);
	float3 gCollisionPositionModifier : packoffset(c225);
	row_major float4x4 gDepthViewProjMtx : packoffset(c226);
	float4 gDispersalSettings : packoffset(c230);
	float2 gGustSpacing : packoffset(c231);
};

SamplerState ParticlePosXYTexSampler : register(s0);
SamplerState ParticlePosZWTexSampler : register(s1);
SamplerState NoiseTexSampler : register(s5);
SamplerState InitPositionTexSampler : register(s6);
SamplerState InitVelocityTexSampler : register(s7);
Texture2D ParticlePosXYTexSampler_tex : register(t0);
Texture2D ParticlePosZWTexSampler_tex : register(t1);
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
	r0.xy = (gGustSpacing.xy == float2(1, 1)) ? -1 : 0;
	r0.x = r0.y & r0.x;
	if (r0.x != 0) {
		r0 = asint(InitPositionTexSampler_tex.Sample(InitPositionTexSampler, i.texcoord.xy));
		r1 = InitVelocityTexSampler_tex.Sample(InitVelocityTexSampler, i.texcoord.xy);
	} else {
		r0 = asint(ParticlePosXYTexSampler_tex.Sample(ParticlePosXYTexSampler, i.texcoord.xy));
		r1 = ParticlePosZWTexSampler_tex.Sample(ParticlePosZWTexSampler, i.texcoord.xy);
	}
	r0.w = asint(asfloat(r0.w) + -(Acceleration_Delta.w));
	r2.x = (0 >= asfloat(r0.w)) ? -1 : 0;
	r2.yz = asint(asfloat(r0.xy) * float2(0.0625, 0.0625) + i.texcoord.xy);
	r3 = NoiseTexSampler_tex.Sample(NoiseTexSampler, asfloat(r2.yz));
	if (r2.x != 0) {
		r2 = asint(NoiseTexSampler_tex.Sample(NoiseTexSampler, i.texcoord.xy));
		r2.xyz = asint(asfloat(r2.xyz) * float3(2, 2, 2) + float3(-1, -1, -1));
		r1.xyz = EmitterVelocityBoxRange.xyz * asfloat(r2.xyz) + EmitterVelocityBoxPos.xyz;
		r2.xyz = asint(r3.wzy * float3(2, 2, 2) + float3(-1, -1, -1));
		r2.xyz = asint(EmitterParamPosRange.xyz * asfloat(r2.xyz) + EmitterTransform[3].xyz);
		r3.xyz = -(EmitterTransform[2].xyz) * EmitterParamPos.yyy;
		r2.xyz = asint(r3.xyz * float3(1, 1, 0) + asfloat(r2.xyz));
		r2.xyz = asint(EmitterParamPos.zzz * float3(0, 0, 1) + asfloat(r2.xyz));
		r3.xy = asfloat(r2.xy) + -(EmitterTransform[3].xy);
		r2.w = asint(dot(r3.xy, r3.xy));
		r2.w = asint(sqrt(asfloat(r2.w)));
		r2.w = asint(asfloat(r2.w) + -(gDispersalSettings.x));
		r2.w = asint(max(asfloat(r2.w), 0));
		r2.w = asint(asfloat(r2.w) * gDispersalSettings.y + 1);
		r2.xy = asint(r3.xy * asfloat(r2.ww) + EmitterTransform[3].xy);
		r0.xyz = asint(-(r1.xyz) * float3(0.200000003, 0.200000003, 0.200000003) + asfloat(r2.xyz));
		o.sv_target.w = EmitterParamLifeAndSpeed.w * r3.w + EmitterParamLifeAndSpeed.z;
		r1.w = 0;
	} else {
		o.sv_target.w = asfloat(r0.w);
	}
	o.sv_target.xyz = r1.xyz * Acceleration_Delta.www + asfloat(r0.xyz);
	r0.x = (0 < r1.w) ? -1 : 0;
	r0.xyz = (r0.xxx != 0) ? asint(gCollisionVelocityModifier.xyz) : int3(1065344827, 1065344827, 1065344827);
	r2.xyz = asint(Acceleration_Delta.xyz * Acceleration_Delta.www + r1.xyz);
	r1.xyz = asfloat(r0.xyz) * asfloat(r2.xyz);
	o.sv_target1 = r1;

	return o;
}
