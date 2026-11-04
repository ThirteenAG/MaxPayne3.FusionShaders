cbuffer ShadowParam : register(b8)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gShadowParam14151617 : packoffset(c1);
	float4 gShadowParam0123 : packoffset(c2);
};

struct PS_IN
{
	float4 sv_position : SV_Position;
	float2 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	float3 r0;
	r0.x = i.texcoord.x / i.texcoord.y;
	r0.x = -(r0.x) + 1;
	r0.y = ddx_coarse(r0.x);
	r0.z = ddy_coarse(r0.x);
	r0.y = max(abs(r0.z), abs(r0.y));
	r0.y = gShadowParam0123.y * r0.y + gShadowParam0123.x;
	o = r0.y + r0.x;

	return o;
}
