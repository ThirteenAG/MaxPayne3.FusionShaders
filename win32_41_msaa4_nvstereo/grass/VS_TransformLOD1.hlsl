cbuffer rage_matrices : register(b0)
{
	row_major float4x4 gWorld : packoffset(c0);
	row_major float4x4 gWorldView : packoffset(c4);
	row_major float4x4 gWorldViewProj : packoffset(c8);
};

cbuffer PlanetAttributes : register(b4)
{
	row_major float4x4 matGrassTransform : packoffset(c0);
	float4 plantColor : packoffset(c4);
	float4 groundColor : packoffset(c5);
	float3 vecCameraPos : packoffset(c6);
	float3 vecPlayerPos : packoffset(c7);
	float4 _dimensionLOD2 : packoffset(c8);
	float2 _vecCollParams : packoffset(c9);
	float4 _vecVehCollB : packoffset(c10);
	float4 _vecVehCollM : packoffset(c11);
	float4 _vecVehCollR : packoffset(c12);
	float4 fadeAlphaDistUmTimer : packoffset(c13);
	float4 fadeAlphaLOD1Dist : packoffset(c14);
	float4 fadeAlphaLOD2Dist : packoffset(c15);
	float4 uMovementParams : packoffset(c16);
	float4 _fakedGrassNormal : packoffset(c17);
};

struct VS_IN
{
	float4 position : POSITION;
	float4 color1 : COLOR1;
	float2 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 sv_position : SV_Position;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float3 r0;
	float4 r1;
	r0 = i.position.yyy * matGrassTransform[1].xyz;
	r0 = i.position.xxx * matGrassTransform[0].xyz + r0.xyz;
	r0 = i.position.zzz * matGrassTransform[2].xyz + r0.xyz;
	r0 = r0.xyz + matGrassTransform[3].xyz;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.sv_position = r1 + gWorldViewProj[3];
	r1.xy = r0.xy + -(vecCameraPos.xy);
	o.texcoord2.xyz = r0.xyz;
	r0.x = dot(r1.xy, r1.xy);
	r0.xy = saturate(r0.xx * fadeAlphaLOD1Dist.yw + fadeAlphaLOD1Dist.xz);
	r0.x = -(r0.x) + 1;
	r0.x = r0.y * r0.x;
	o.texcoord.w = r0.x * plantColor.w;
	o.texcoord.xyz = plantColor.xyz;
	o.texcoord1.xyz = _fakedGrassNormal.xyz;
	o.texcoord1.w = i.texcoord.x;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3.w = min(i.color1.x, 1);
	o.texcoord3.xyz = groundColor.xyz;

	return o;
}
