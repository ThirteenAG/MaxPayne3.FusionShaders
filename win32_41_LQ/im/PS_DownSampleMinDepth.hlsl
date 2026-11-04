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
};

SamplerState DepthMapPointSampler : register(s4);
Texture2D DepthMapPointSampler_tex : register(t4);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float4 color : COLOR;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float sv_depth : SV_Depth;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	o.sv_target = float4(1, 0, 0, 1);
	r0 = i.texcoord.xyxy + globalScreenSize.zwzw;
	r1 = globalScreenSize.zwzw * float4(-0.5, -0.5, 0.5, -0.5) + r0.zwzw;
	r0 = globalScreenSize.zwzw * float4(-0.5, 0.5, 0.5, 0.5) + r0;
	r1.x = DepthMapPointSampler_tex.Sample(DepthMapPointSampler, r1.xy).x;
	r1.y = DepthMapPointSampler_tex.Sample(DepthMapPointSampler, r1.zw).x;
	r1.x = min(r1.y, r1.x);
	r0.x = DepthMapPointSampler_tex.Sample(DepthMapPointSampler, r0.xy).x;
	r0.y = DepthMapPointSampler_tex.Sample(DepthMapPointSampler, r0.zw).x;
	r0.x = min(r0.y, r0.x);
	o.sv_depth = min(r0.x, r1.x);

	return o;
}
