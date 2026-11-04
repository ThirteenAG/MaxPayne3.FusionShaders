float2 gRescaleUV1 : register(c94);
float2 gRescaleUV2 : register(c95);
float2 gRescaleUV3 : register(c96);
float2 gUVOffset[3] : register(c38);
float2 gUVOffset1 : register(c91);
float2 gUVOffset2 : register(c92);
float2 gUVOffset3 : register(c93);
row_major float4x4 gWorldViewProj : register(c8);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0 = gWorldViewProj[1].xyww * i.position.y;
	r0 = i.position.x * gWorldViewProj[0].xyww + r0;
	r0 = i.position.z * gWorldViewProj[2].xyww + r0;
	o.position = r0 + gWorldViewProj[3].xyww;
	r0.xy = gRescaleUV1.xy;
	r0.xy = i.texcoord.xy * r0.xy + gUVOffset1.xy;
	o.texcoord1 = r0.xy + gUVOffset[0].xy;
	r0.xy = gRescaleUV2.xy;
	r0.xy = i.texcoord.xy * r0.xy + gUVOffset2.xy;
	o.texcoord2.xy = r0.xy + gUVOffset[1].xy;
	r0.xy = gRescaleUV3.xy;
	r0.xy = i.texcoord.xy * r0.xy + gUVOffset3.xy;
	o.texcoord2.zw = r0.xy + gUVOffset[2].xy;

	return o;
}
