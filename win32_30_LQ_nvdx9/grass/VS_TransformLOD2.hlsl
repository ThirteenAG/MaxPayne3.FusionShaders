float4 _dimensionLOD2 : register(c72);
float4 _fakedGrassNormal : register(c91);
float4 fadeAlphaLOD2Dist : register(c89);
row_major float4x4 gViewInverse : register(c12);
row_major float4x4 gWorldViewProj : register(c8);
float4 groundColor : register(c69);
row_major float4x4 matGrassTransform : register(c64);
float4 plantColor : register(c68);
float3 vecCameraPos : register(c70);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
	float4 texcoord3 : TEXCOORD3;
};

VS_OUT main(float4 texcoord : TEXCOORD)
{
	VS_OUT o;

	float4 r0;
	float4 r1;
	float3 r2;
	r0.x = texcoord.y * 0.5 + 0.5;
	o.texcoord2.w = min(r0.x, 1);
	r0.z = 1E-05;
	r0.xyw = r0.zzz + gViewInverse[0].xyz;
	r1.xyz = normalize(r0.xyw);
	r0.xyw = r1.xyz * _dimensionLOD2.xxx;
	r1.xyz = r0.zzz + -gViewInverse[1].xyz;
	r2 = normalize(r1.xyz);
	r1.xyz = r2.xyz * _dimensionLOD2.yyy;
	r2.xy = float2(-0.5, -0) + texcoord.xy;
	r1.xyz = r1.xyz * r2.yyy;
	r0.xyz = r2.xxx * r0.xyw + r1.xyz;
	r1.xyz = r0.yyy * matGrassTransform[1].xyz;
	r0.xyw = r0.xxx * matGrassTransform[0].xyz + r1.xyz;
	r0.z = r0.z + _dimensionLOD2.y;
	r0.xyz = r0.zzz * matGrassTransform[2].xyz + r0.xyw;
	r0.xyz = r0.xyz + matGrassTransform[3].xyz;
	r1.xy = r0.xy + -vecCameraPos.xy;
	r1.xy = r1.xy * r1.xy;
	r0.w = r1.y + r1.x;
	r1.xy = saturate(r0.ww * fadeAlphaLOD2Dist.yw + fadeAlphaLOD2Dist.xz);
	r0.w = -r1.x + 1;
	r0.w = r1.y * r0.w;
	r1.x = texcoord.y * 0.5 + -r1.y;
	r1.x = r1.x + 1;
	o.texcoord3.w = min(r1.x, 1);
	o.texcoord.w = r0.w * plantColor.w;
	r1 = r0.y * gWorldViewProj[1];
	r1 = r0.x * gWorldViewProj[0] + r1;
	r1 = r0.z * gWorldViewProj[2] + r1;
	o.texcoord2.xyz = r0.xyz;
	o.position = r1 + gWorldViewProj[3];
	o.texcoord.xyz = plantColor.xyz;
	o.texcoord1.xyz = _fakedGrassNormal.xyz;
	o.texcoord1.w = texcoord.x;
	o.texcoord3.xyz = groundColor.xyz;

	return o;
}
