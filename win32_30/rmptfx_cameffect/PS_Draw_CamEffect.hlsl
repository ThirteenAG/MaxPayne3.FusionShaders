sampler2D DiffuseTexSampler : register(s0);
float4 globalScalars4 : register(c51);

struct PS_IN
{
	float4 texcoord : TEXCOORD;
	float2 texcoord1 : TEXCOORD1;
	float2 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	float4 r1;
	r0.x = globalScalars4.x * i.texcoord2.y;
	r1 = tex2D(DiffuseTexSampler, i.texcoord1.xy);
	r1 = r1 * i.texcoord;
	r1.xyz = r0.xxx * r1.xyz;
	r1.w = saturate(r1.w);
	r0 = max(r1, 0);
	o = min(r0, 32);

	return o;
}
