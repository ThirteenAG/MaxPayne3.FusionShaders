SamplerState DepthMapPointSampler : register(s3);
Texture2D DepthMapPointSampler_tex : register(t3);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
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
	o.sv_target = float4(1, 0, 0, 1);
	r0 = DepthMapPointSampler_tex.Sample(DepthMapPointSampler, i.texcoord.xy);
	o.sv_depth = r0.x;

	return o;
}
