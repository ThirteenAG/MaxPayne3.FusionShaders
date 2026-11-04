float4 _fakedGrassNormal : register(c91);
float4 fadeAlphaLOD1Dist : register(c88);
row_major float4x4 gWorldViewProj : register(c8);
float4 groundColor : register(c69);
row_major float4x4 matGrassTransform : register(c64);
float4 plantColor : register(c68);
float3 vecCameraPos : register(c70);

struct VS_IN
{
	float4 position : POSITION;
	float4 color1 : COLOR1;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	r0.xyz = matGrassTransform[1].xyz * i.position.yyy;
	r0.xyz = i.position.xxx * matGrassTransform[0].xyz + r0.xyz;
	r0.xyz = i.position.zzz * matGrassTransform[2].xyz + r0.xyz;
	r0.xyz = r0.xyz + matGrassTransform[3].xyz;
	r1.xy = r0.xy + -vecCameraPos.xy;
	r1.xy = r1.xy * r1.xy;
	r0.w = r1.y + r1.x;
	r1.xy = saturate(r0.ww * fadeAlphaLOD1Dist.yw + fadeAlphaLOD1Dist.xz);
	r0.w = -r1.x + 1;
	r0.w = r1.y * r0.w;
	o.texcoord.w = r0.w * plantColor.w;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.texcoord2.xyz = r0.xyz;
	o.position = r1 + gWorldViewProj[3];
	o.texcoord3.w = min(1, i.color1.x);
	o.texcoord.xyz = plantColor.xyz;
	o.texcoord1.xyz = _fakedGrassNormal.xyz;
	o.texcoord1.w = i.texcoord.x;
	o.texcoord2.w = i.texcoord.y;
	o.texcoord3.xyz = groundColor.xyz;

	return o;
}
