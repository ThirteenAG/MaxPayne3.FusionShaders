float4 globalScreenSize : register(c41);

struct VS_OUT
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float2 r0;
	r0.x = 1 / globalScreenSize.x;
	r0.y = 1 / globalScreenSize.y;
	r0 = r0.xy * float2(-0.5, 0.5) + position.xy;
	o.position.xy = r0.xy * 2 + -1;
	o.position.zw = position.zz * float2(1, 0) + float2(0, 1);
	o.texcoord = position.xyxz * float4(1, -1, 0, 0) + float4(0, 1, 0, 1);

	return o;
}
