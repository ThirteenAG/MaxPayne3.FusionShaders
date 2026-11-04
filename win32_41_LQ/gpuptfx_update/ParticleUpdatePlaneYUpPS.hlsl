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
	int4 r1;
	float4 r2;
	float4 r3;
	float4 r4;
	float4 r5;
	r0.xy = (gGustSpacing.xy == float2(1, 1)) ? -1 : 0;
	r0.x = r0.y & r0.x;
	if (r0.x != 0) {
		r0 = asint(InitPositionTexSampler_tex.Sample(InitPositionTexSampler, i.texcoord.xy));
		r1 = asint(InitVelocityTexSampler_tex.Sample(InitVelocityTexSampler, i.texcoord.xy));
	} else {
		r0 = asint(ParticlePosXYTexSampler_tex.Sample(ParticlePosXYTexSampler, i.texcoord.xy));
		r1 = asint(ParticlePosZWTexSampler_tex.Sample(ParticlePosZWTexSampler, i.texcoord.xy));
	}
	r2.x = asfloat(r0.w) + -(Acceleration_Delta.w);
	r0.w = (0 >= r2.x) ? -1 : 0;
	r3.xy = asfloat(r0.xz) * float2(0.0625, 0.0625) + i.texcoord.xy;
	r3.xyz = NoiseTexSampler_tex.Sample(NoiseTexSampler, r3.xy).yzw;
	if (r0.w != 0) {
		r4.xyz = NoiseTexSampler_tex.Sample(NoiseTexSampler, i.texcoord.xy).xyz;
		r4.yzw = r4.xyz * float3(2, 2, 2) + float3(-1, -1, -1);
		r1.xyz = asint(EmitterVelocityBoxRange.xyz * r4.yzw + EmitterVelocityBoxPos.xyz);
		r3.xyw = r3.zyx * float3(2, 2, 2) + float3(-1, -1, -1);
		r3.xyw = EmitterParamPosRange.xyz * r3.xyw + EmitterParamPos.xyz;
		r4.yzw = r3.yyy * EmitterTransform[1].xyz;
		r4.yzw = r3.xxx * EmitterTransform[0].xyz + r4.yzw;
		r3.xyw = r3.www * EmitterTransform[2].xyz + r4.yzw;
		r5.y = r3.y + EmitterTransform[3].y;
		r0.w = asint(dot(r3.xw, r3.xw));
		r0.w = asint(sqrt(asfloat(r0.w)));
		r0.w = asint(asfloat(r0.w) + -(gDispersalSettings.x));
		r0.w = asint(max(asfloat(r0.w), 0));
		r0.w = asint(asfloat(r0.w) * gDispersalSettings.y + 1);
		r5.xz = r3.xw * asfloat(r0.ww) + EmitterTransform[3].xz;
		r0.xyz = asint(-(asfloat(r1.xyz)) * float3(0.200000003, 0.200000003, 0.200000003) + r5.xyz);
		r2.x = EmitterParamLifeAndSpeed.w * r3.z + EmitterParamLifeAndSpeed.z;
		r0.w = (r4.x < EmitterParamProbablityPhase2) ? -1 : 0;
		r1.w = 0;
	} else {
		r0.w = 0;
	}
	r3.xyz = asfloat(r1.xyz) * Acceleration_Delta.www + asfloat(r0.xyz);
	r3.w = 1;
	r0.x = asint(dot(r3, gHitPlane));
	r0.y = (asfloat(r0.x) < 0) ? -1 : 0;
	r0.y = r0.w | r0.y;
	r4.xyz = -(gHitPlane.xyz) * asfloat(r0.xxx) + r3.xyz;
	r5.xyz = asfloat(r1.xyz) * gCollisionVelocityModifier.xyz;
	r0.x = (asfloat(r1.w) == 0) ? -1 : 0;
	r0.z = asint(r2.x * gCollisionLifeModifier.x + gCollisionLifeModifier.y);
	r4.w = (r0.x != 0) ? asfloat(r0.z) : r2.x;
	r5.w = asfloat(r1.w) + 1;
	r2.yzw = r3.xyz;
	o.sv_target = (r0.y != 0) ? r4 : r2.yzwx;
	r0 = (r0.y != 0) ? asint(r5) : r1;
	r1.x = (0 < asfloat(r0.w)) ? -1 : 0;
	r1.xyz = (r1.xxx != 0) ? asint(gCollisionVelocityModifier.xyz) : int3(1065344827, 1065344827, 1065344827);
	r0.xyz = asint(Acceleration_Delta.xyz * Acceleration_Delta.www + asfloat(r0.xyz));
	o.sv_target1.xyz = asfloat(r1.xyz) * asfloat(r0.xyz);
	o.sv_target1.w = asfloat(r0.w);

	return o;
}
