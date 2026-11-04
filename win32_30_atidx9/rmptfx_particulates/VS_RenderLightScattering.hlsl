float4 gFrustumParameters : register(c98);
row_major float4x4 gViewInverse : register(c12);

struct VS_IN
{
	float4 position : POSITION;
	float4 texcoord : TEXCOORD;
};

struct VS_OUT
{
	float4 position : POSITION;
	float2 texcoord : TEXCOORD;
	float3 texcoord2 : TEXCOORD2;
};

VS_OUT main(VS_IN i)
{
	VS_OUT o;

	float4 r0;
	r0.xy = gFrustumParameters.zw * i.position.xy;
	r0.yzw = r0.yyy * gViewInverse[1].xyz;
	r0.xyz = r0.xxx * gViewInverse[0].xyz + r0.yzw;
	o.texcoord2 = r0.xyz + -gViewInverse[2].xyz;
	o.position = i.position;
	o.texcoord = i.texcoord.xy;

	return o;
}
