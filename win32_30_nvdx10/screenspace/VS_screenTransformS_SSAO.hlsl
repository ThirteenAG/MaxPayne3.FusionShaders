float4 gooDeferredLightScreenSize : register(c118);

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	r0.xy = position.xy * float2(1, -1) + float2(0, 1);
	r0.w = 0.5;
	o.texcoord = gooDeferredLightScreenSize.zw * r0.ww + r0.xy;
	o.position = position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);

	return o;
}
