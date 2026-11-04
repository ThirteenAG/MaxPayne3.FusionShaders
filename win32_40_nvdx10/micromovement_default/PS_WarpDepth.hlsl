cbuffer rage_globals : register(b5)
{
	float4 globalScalars : packoffset(c0);
};

cbuffer ShadowParam : register(b10)
{
	float4 gShadowParam18192021 : packoffset(c0);
	float4 gFacetCentre : packoffset(c1);
	float4 gShadowParam14151617 : packoffset(c2);
};

SamplerState DiffuseSampler : register(s0);
SamplerState gStippleAlphaTexture : register(s13);
Texture2D DiffuseSampler_tex : register(t0);
Texture2D gStippleAlphaTexture_tex : register(t13);

struct PS_IN
{
	noperspective float4 sv_position : SV_Position;
	float4 texcoord1 : TEXCOORD1;
	float4 texcoord : TEXCOORD;
};

float4 main(PS_IN i) : SV_Target
{
	float4 o;

	int4 r0;
	int4 r1;
	r0.x = asint(-(i.texcoord1.z) + 0.00999999978);
	r0.y = (gShadowParam14151617.x == 0) ? -1 : 0;
	r0.y = r0.y & 1065353216;
	r0.x = asint(asfloat(r0.y) * asfloat(r0.x));
	r0.x = (asfloat(r0.x) < 0) ? -1 : 0;
	if (r0.x != 0) discard;
	r0 = asint(DiffuseSampler_tex.Sample(DiffuseSampler, i.texcoord.xy));
	r0.x = asint(asfloat(r0.w) * globalScalars.x);
	r0.y = asint(saturate(asfloat(r0.x)));
	r0.y = asint(asfloat(r0.y) * 3.99600005);
	r0.z = asint(frac(asfloat(r0.y)));
	r0.z = asint(asfloat(r0.z) * 4);
	r1.xy = asint(floor(asfloat(r0.zy)));
	r0.yz = asint(i.sv_position.xy * float2(0.125, 0.125));
	r1.zw = (asfloat(r0.yz) >= -(asfloat(r0.yz))) ? -1 : 0;
	r0.yz = asint(frac(abs(asfloat(r0.yz))));
	r0.yz = (r1.zw != 0) ? r0.yz : asint(-(asfloat(r0.yz)));
	r0.yz = asint(asfloat(r0.yz) * float2(0.25, 0.25));
	r0.yz = asint(asfloat(r1.xy) * float2(0.25, 0.25) + asfloat(r0.yz));
	r1 = asint(gStippleAlphaTexture_tex.Sample(gStippleAlphaTexture, asfloat(r0.yz)));
	r0.y = (0 >= asfloat(r1.y)) ? -1 : 0;
	if (r0.y != 0) discard;
	o.xyz = i.texcoord1.www;
	o.w = asfloat(r0.x);

	return o;
}
