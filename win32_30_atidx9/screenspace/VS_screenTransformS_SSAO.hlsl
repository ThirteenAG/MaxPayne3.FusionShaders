float4 gDeferredProjParams : register(c119);
row_major float4x4 gViewInverse : register(c12);
float4 gooDeferredLightScreenSize : register(c118);

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord2 : TEXCOORD2;
};

VS_OUT main(float4 position : POSITION)
{
	VS_OUT o;

	float4 r0;
	r0.y = 0.5;
	r0.xz = gooDeferredLightScreenSize.zw * r0.yy + position.xy;
	o.texcoord2.y = -r0.z + 1;
	o.texcoord2.x = r0.x;
	r0.x = position.x;
	o.texcoord.x = gooDeferredLightScreenSize.z * r0.y + r0.x;
	r0.x = gooDeferredLightScreenSize.w * r0.y + -position.y;
	o.texcoord.y = r0.x + 1;
	r0.xy = -0.5 + position.xy;
	r0.xy = r0.xy + r0.xy;
	r0.xy = r0.xy * gDeferredProjParams.xy;
	r0.yzw = -r0.yyy * gViewInverse[1].xyz;
	r0.xyz = -r0.xxx * gViewInverse[0].xyz + r0.yzw;
	o.texcoord1.xyz = r0.xyz + gViewInverse[2].xyz;
	o.position = position.xyxx * float4(2, 2, 0, 0) + float4(-1, -1, 0, 1);
	o.texcoord1.w = 1;
	o.texcoord2.zw = float2(0, 1);

	return o;
}
