sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c32);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float2 r0;
	float4 r1;
	float4 r2;
	r0.x = abs(HybridAdd.x);
	r0.y = 1 + -i.texcoord3.x;
	r1 = tex2D(DiffuseTexSampler, i.texcoord.xy);
	r1 = r1 * i.color;
	r2.w = r0.y * r1.w;
	r2.xyz = r1.www * r1.xyz;
	o = (-r0.x >= 0) ? r1 : r2;

	return o;
}
