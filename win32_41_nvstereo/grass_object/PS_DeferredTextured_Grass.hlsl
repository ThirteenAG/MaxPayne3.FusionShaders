SamplerState DiffuseSampler : register(s0);
Texture2D DiffuseSampler_tex : register(t0);

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
};

struct PS_OUT
{
	float4 sv_target : SV_Target;
	float4 sv_target1 : SV_Target1;
	float4 sv_target2 : SV_Target2;
	float4 sv_target3 : SV_Target3;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	r0 = DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy);
	o.sv_target.w = r0.w * i.texcoord6.w;
	o.sv_target.xyz = r0.xyz;
	o.sv_target1.xyz = i.texcoord1.xyz;
	o.sv_target1.w = 0;
	o.sv_target2.xyz = i.texcoord6.xyz;
	o.sv_target2.w = 0;
	o.sv_target3 = float4(0, 0, 0, 0);

	return o;
}
