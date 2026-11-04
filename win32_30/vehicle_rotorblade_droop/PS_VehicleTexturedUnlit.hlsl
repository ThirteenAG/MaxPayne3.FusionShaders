sampler2D DiffuseSampler : register(s0);
float4 globalScalars : register(c35);
float3 matDiffuseColor : register(c198);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord2 : TEXCOORD2;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xyz = r0.xyz * matDiffuseColor.xyz;
	r0 = r0 * i.texcoord2;
	o.w = r0.w * globalScalars.x;
	o.xyz = r0.xyz;

	return o;
}
