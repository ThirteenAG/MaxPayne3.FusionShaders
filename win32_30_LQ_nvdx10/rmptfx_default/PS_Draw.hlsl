sampler2D DiffuseTexSampler : register(s0);
float HybridAdd : register(c32);

struct PS_IN
{
	float4 color : COLOR;
	float4 texcoord : TEXCOORD;
	float texcoord2 : TEXCOORD2;
	float texcoord3 : TEXCOORD3;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	float r2;
	float4 r3;
	r0 = tex2D(DiffuseTexSampler, i.texcoord.xy);
	r1 = tex2D(DiffuseTexSampler, i.texcoord.zw);
	r2 = saturate(i.texcoord2.x);
	r3 = lerp(r0, r1, r2.x);
	r0 = r3 * i.color;
	r1.x = 1 + -i.texcoord3.x;
	r1.w = r0.w * r1.x;
	r1.xyz = r0.www * r0.xyz;
	r2 = abs(HybridAdd.x);
	o = (-r2.x >= 0) ? r0 : r1;

	return o;
}
