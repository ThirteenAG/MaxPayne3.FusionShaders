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
	uint sv_coverage : SV_Coverage;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	int4 r0;
	int4 r1;
	int3 r2;
	r0 = asint(ddy_coarse(i.texcoord.xyxy));
	r0 = asint(asfloat(r0) * float4(0.25, 0.25, -0.25, -0.25));
	r1 = asint(ddx_coarse(i.texcoord.xyxy));
	r0 = asint(asfloat(r1) * float4(0.25, 0.25, -0.25, -0.25) + asfloat(r0));
	r0 = asint(asfloat(r0) + i.texcoord.xyxy);
	r1 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.xy)).xwyz);
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, asfloat(r0.zw)));
	r2 = asint(asfloat(r1.yyy) * asfloat(r1.xzw));
	r1.z = asint(asfloat(r1.y) + -0.5);
	r1.z = (asfloat(r1.z) >= 0) ? -1 : 0;
	r2 = r2.xyz & r1.zzz;
	r0.xyz = asint(asfloat(r0.xyz) * asfloat(r0.www) + asfloat(r2.xyz));
	r1.w = asint(asfloat(r0.w) + -0.5);
	r1.w = (asfloat(r1.w) >= 0) ? -1 : 0;
	r0.xyz = (r1.www != 0) ? r0.xyz : r2.xyz;
	r1.x = 1;
	r1.xy = r1.xy & r1.zz;
	r2.x = (2 & ~1) | (r1.z & 1);
	r2.y = asint(asfloat(r0.w) + asfloat(r1.y));
	r1.xy = (r1.ww != 0) ? r2.xy : r1.xy;
	o.sv_target.xyz = asfloat(r0.xyz) / asfloat(r1.yyy);
	o.sv_target.w = asfloat(r1.y) * i.texcoord6.w;
	o.sv_coverage = r1.x;
	o.sv_target1.xyz = i.texcoord1.xyz;
	o.sv_target1.w = 0;
	o.sv_target2.xyz = i.texcoord6.xyz;
	o.sv_target2.w = 1000;
	o.sv_target3 = float4(0, 0, 0, 0);

	return o;
}
