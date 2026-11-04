sampler2D DiffuseSampler : register(s1);

struct PS_IN
{
	float2 texcoord : TEXCOORD;
	float4 texcoord1 : TEXCOORD1;
};

float4 main(PS_IN i) : COLOR
{
	float4 o;

	float4 r0;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.xyz = r0.xyz * i.texcoord1.xyz;
	r0.xyz = r0.xyz * i.texcoord1.www;
	r0.xyz = saturate(r0.xyz * 0.0625);
	r0.x = rsqrt(r0.x);
	o.x = 1 / r0.x;
	r0.x = rsqrt(r0.y);
	r0.y = rsqrt(r0.z);
	o.z = 1 / r0.y;
	o.y = 1 / r0.x;
	o.w = 1;

	return o;
}
