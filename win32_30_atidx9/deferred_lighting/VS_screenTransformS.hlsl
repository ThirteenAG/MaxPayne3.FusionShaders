float4 gDeferredProjParams : register(c216);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c215);

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	float r1;
	r0.xy = position.xy * float2(1, -1) + float2(0, 1);
	r1 = -0.5;
	o.texcoord = gooDeferredLightScreenSize.zw * -r1.xx + r0.xy;
	r0.xy = -0.5 + position.xy;
	r0.xy = r0.xy + r0.xy;
	r0.xy = r0.xy * gDeferredProjParams.xy;
	r0.yzw = -r0.yyy * gViewInverse[1].xyz;
	r0.xyz = -r0.xxx * gViewInverse[0].xyz + r0.yzw;
	o.texcoord1.xyz = r0.xyz + gViewInverse[2].xyz;
	o.position = position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);
	o.texcoord1.w = 1;

	return o;
}
