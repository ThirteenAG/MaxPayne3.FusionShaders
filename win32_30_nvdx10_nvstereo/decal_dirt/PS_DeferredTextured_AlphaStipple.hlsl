sampler2D DiffuseSampler : register(s0);
float3 dirtDecalMask : register(c196);
float4 globalScalars : register(c35);
float specularColorFactor : register(c198);
float specularFactor : register(c197);
float4 stipplePattern : register(c62);

struct PS_IN
{
	float4 color : COLOR;
	float2 texcoord : TEXCOORD;
	float2 vpos : VPOS;
};

struct PS_OUT
{
	float4 color2 : COLOR2;
	float4 color : COLOR;
	float4 color3 : COLOR3;
	float4 color1 : COLOR1;
};

PS_OUT main(PS_IN i)
{
	PS_OUT o;

	float4 r0;
	float4 r1;
	float4 r2;
	r0 = tex2D(DiffuseSampler, i.texcoord.xy);
	r0.x = dot(r0.xyz, dirtDecalMask.xyz);
	r0.x = r0.x * i.color.w;
	r1.w = r0.x * globalScalars.x;
	r0.yz = 0.5 * i.vpos.xy;
	r0.yz = frac(abs(r0.yz));
	r0.yz = (i.vpos.xy >= 0) ? r0.yz : -r0.yz;
	r0.yz = r0.yz + r0.yz;
	r2.xy = frac(r0.yz);
	r0.yz = r0.yz + -r2.xy;
	r0.y = r0.z * 2 + r0.y;
	r2 = r0.y + float4(-0, -1, -2, -3);
	r2 = (-abs(r2) >= 0) ? 1 : 0;
	r0.y = dot(stipplePattern, r2);
	r0.x = r0.x * -globalScalars.x + r0.y;
	r0 = (r0.x >= 0) ? -1 : -0;
	clip(r0);
	r0.zw = float2(1, 0);
	r0.x = r0.z + -specularFactor.x;
	r2.x = specularFactor.x;
	r0.y = saturate(r2.x * 0.0051020407);
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	r0.y = rsqrt(r0.y);
	r0.y = 1 / r0.y;
	o.color2.y = (r0.x >= 0) ? 0.26726124 : r0.y;
	o.color.xyz = i.color.xyz;
	o.color.w = r1.w;
	r1.xz = r0.zw * specularColorFactor.xx;
	o.color2.xzw = r1.xzw;
	o.color3 = r1.zzzw;
	o.color1 = 0;

	return o;
}
