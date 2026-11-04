cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

struct DS_IN
{
	float4 texcoord8 : TEXCOORD8;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
	float3 texcoord7 : TEXCOORD7;
};

struct DS_CONST
{
	float edges[3] : SV_TessFactor;
	float inside : SV_InsideTessFactor;
};

struct DS_OUT
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
	float3 texcoord1 : TEXCOORD1;
	float4 texcoord6 : TEXCOORD6;
};

[domain("tri")]
DS_OUT main(DS_CONST constants, float3 sv_domainlocation : SV_DomainLocation, const OutputPatch<DS_IN, 3> patch)
{
	DS_OUT o;

	float3 t0 = patch[0].texcoord8.xyz * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord8.xyz + patch[2].texcoord8.xyz * sv_domainlocation.y;
	o.sv_position = mul(float4(t0, 1), gWorldViewProj);
	o.texcoord = patch[0].texcoord * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord + patch[2].texcoord * sv_domainlocation.y;
	o.texcoord1 = normalize(patch[0].texcoord1 * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord1 + patch[2].texcoord1 * sv_domainlocation.y + 0.00000999999975);
	o.texcoord6 = patch[0].texcoord6 * sv_domainlocation.z + sv_domainlocation.x * patch[1].texcoord6 + patch[2].texcoord6 * sv_domainlocation.y;

	return o;
}
